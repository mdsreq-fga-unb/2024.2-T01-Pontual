from django.db.models import Q, F, functions, Count
from django.shortcuts import render, get_object_or_404
from django.utils import timezone
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, exceptions
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from core.permissions import IsAdminUserNotSafe
from .models import Class, Status, Report, Notification, Message
from core.utils.serializers import ClassSerializer, ClassPostSerializer, StatusSerializer, ClassRetrieveOnlySerializer, ReportSerializer, ReportRetrieveSerializer, ReportPerRangeSerializer, ReportGetSerializer, NotificationSubscribeSerializer, MessageSerializer
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from users.models import User
from datetime import datetime, timedelta
from core.functions import weekday
from pywebpush import webpush, WebPushException
import locale
import json


class ClassApiView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserNotSafe]
    renderer_classes = [JSONRenderer]

    def get(self, request, pk=None, uuid=None, start_date=None, end_date=None):
        if uuid:
            if not request.user.is_staff:
                return Response({"detail": "Permission denied."}, status=status.HTTP_403_FORBIDDEN)

            classes = Class.objects.filter(user__uuid=uuid)
            if not classes.exists():
                return Response({"detail": "No classes found for this user."}, status=status.HTTP_404_NOT_FOUND)
        elif pk:
            classes = Class.objects.filter(pk=pk, user=request.user)
        elif start_date and end_date:
            params = request.query_params
            try:
                start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")
                end_date = datetime.strptime(end_date, "%Y-%m-%dT%H:%M:%S")
            except:
                return Response({
                    "detail": "Invalid date format. Please use the format 'YYYY-MM-DDTHH:MM:SS'."
                }, status=status.HTTP_400_BAD_REQUEST)

            if start_date > end_date:
                return Response({
                    "detail": "The 'start' date must be earlier than the 'end' date."
                }, status=status.HTTP_400_BAD_REQUEST)

            if request.user.is_staff:
                classes = self.get_classes_in_range(start_date, end_date)
            else:
                classes = self.get_classes_in_range(
                    start_date, end_date,
                    request.user
                )

            delayed = []
            exact_time = datetime.now()
            if params.get('tp') == 'delayed':
                current_date = start_date
                for i in range((end_date - start_date).days + 1):
                    current_date = exact_time if i == 4 else start_date + \
                        timedelta(days=i)

                    for status_instance in Status.objects.annotate(
                        expected_date=functions.TruncDate("expected__0")).filter(
                        ~Q(kind="std"),
                        expected_date=current_date,
                        register=None,
                        notes=None
                    ):
                        if status_instance.expected[0] < timezone.make_aware(exact_time):
                            delayed.append({
                                "id": status_instance.id,
                                "kind": status_instance.kind,
                                "name": status_instance.classy.name if status_instance.kind == "rep" else f"VIP: {status_instance.id}",
                                "date": status_instance.expected[0].astimezone(timezone.get_current_timezone()),
                                "user_name": status_instance.user.name if status_instance.kind == "vip" else status_instance.classy.user.name,
                                "user_uuid": status_instance.user.uuid if status_instance.kind == "vip" else status_instance.classy.user.uuid,
                                "delay_in_minutes": (timezone.make_aware(exact_time) - status_instance.expected[0]).total_seconds() // 60
                            })

                    for class_instance in classes.filter(user__is_active=True):
                        if weekday(current_date) in class_instance.days:
                            expect_start = timezone.make_aware(
                                datetime.combine(
                                    current_date,
                                    class_instance.start_time
                                ))
                            expect_end = timezone.make_aware(
                                datetime.combine(
                                    current_date,
                                    class_instance.end_time
                                ))

                            instance = Status.objects.filter(~Q(register__len__lt=1) | ~Q(notes=None),
                                                             classy=class_instance,
                                                             expected=[
                                                                 expect_start, expect_end],
                                                             kind='std'
                                                             )

                            if not instance.exists():
                                if expect_start < timezone.make_aware(exact_time):
                                    delayed.append({
                                        "id": class_instance.id,
                                        "kind": "std",
                                        "name": class_instance.name,
                                        "date": datetime.combine(current_date, class_instance.start_time).astimezone(timezone.get_current_timezone()),
                                        "user_name": class_instance.user.name,
                                        "user_uuid": class_instance.user.uuid,
                                        "delay_in_minutes": (timezone.make_aware(exact_time) - expect_start).total_seconds() // 60
                                    })
                            else:
                                if instance.first().register and len(instance.first().register) == 1:
                                    delayed.append({
                                        "id": class_instance.id,
                                        "kind": "std",
                                        "name": class_instance.name,
                                        "date": datetime.combine(current_date, class_instance.end_time).astimezone(timezone.get_current_timezone()),
                                        "user_name": class_instance.user.name,
                                        "user_uuid": class_instance.user.uuid,
                                        "delay_in_minutes": (timezone.make_aware(exact_time) - expect_end).total_seconds() // 60
                                    })

            delayed.sort(key=lambda x: -x["delay_in_minutes"])
            return Response(delayed, status=status.HTTP_200_OK)
        elif start_date:
            try:
                start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")
            except:
                return Response({
                    "detail": "Invalid date format. Please use the format 'YYYY-MM-DDTHH:MM:SS'."
                }, status=status.HTTP_400_BAD_REQUEST)

            classes = self.get_classes_until_infinity(start_date, request.user)

            serializer = ClassRetrieveOnlySerializer(classes, many=True)
            if not serializer.data:
                return Response({}, status=status.HTTP_404_NOT_FOUND)

            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            classes = Class.objects.filter(user=request.user)

        serializer = ClassSerializer(classes, many=True)
        if not serializer.data:
            return Response({}, status=status.HTTP_404_NOT_FOUND)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = ClassPostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, pk):
        instance = get_object_or_404(Class, pk=pk)
        serializer = ClassSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        instance = get_object_or_404(Class, pk=pk)
        instance.delete()
        return Response({}, status=status.HTTP_204_NO_CONTENT)

    @staticmethod
    def generate_days_range(start_date, end_date):
        days_in_range = []

        if weekday(start_date) < weekday(end_date):
            days_in_range = list(
                range(weekday(start_date), weekday(end_date) + 1))
        elif weekday(start_date) == weekday(end_date):
            if start_date.date() == end_date.date():
                days_in_range = [weekday(start_date)]
            else:
                days_in_range = list(range(0, 7))
        else:
            days_in_range = list(range(weekday(start_date), 7)) + \
                list(range(0, weekday(end_date) + 1))

        return days_in_range

    @classmethod
    def get_classes_in_range(cls, start_date, end_date, user=None):
        start_date = timezone.make_aware(start_date)
        end_date = timezone.make_aware(end_date)

        days_in_range = cls.generate_days_range(start_date, end_date)
        classes = Class.objects.filter(
            Q(start_range__lte=end_date) & Q(end_range__gte=start_date),
            Q(days__overlap=days_in_range), user=user if user else Q()
        )

        for class_instance in classes:
            temporary_days_range = cls.generate_days_range(
                start_date, class_instance.end_range)

            if not set(class_instance.days).intersection(set(temporary_days_range)):
                classes = classes.exclude(id=class_instance.id)

        return classes

    def get_classes_until_infinity(self, start_date, user):
        start_date = timezone.make_aware(start_date)
        classes = Class.objects.filter(
            Q(start_range__gte=start_date),
            user=user
        )

        return classes


class StatusApiView(APIView):
    permission_classes = [IsAuthenticated]
    renderer_classes = [JSONRenderer]

    def get_status_in_range(self, start_date, end_date, user, tp, at):
        start_date = timezone.make_aware(start_date)
        end_date = timezone.make_aware(end_date)

        statuses = Status.objects.filter(
            Q(expected__0__lte=end_date) & Q(expected__1__gte=start_date),
            (Q(classy__user=user) | Q(user=user)) if user else Q(),
            Q(kind=tp) if tp else Q(),
            Q(register__len=2) if at else Q()
        ).order_by('id')

        return statuses

    def get(self, request, pk=None, uuid=None, start_date=None, end_date=None):
        params = request.query_params

        if uuid:
            if not request.user.is_staff and request.user.uuid != uuid:
                return Response(
                    {"detail": "Permission denied."},
                    status=status.HTTP_403_FORBIDDEN
                )

            statuses = Status.objects.filter(classy__user=uuid)

            if not statuses.exists():
                return Response(
                    {"detail": "No status found for this user."},
                    status=status.HTTP_404_NOT_FOUND
                )
        elif start_date and end_date:
            try:
                start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")
                end_date = datetime.strptime(end_date, "%Y-%m-%dT%H:%M:%S")
            except:
                return Response({
                    "detail": "Invalid date format. Please use the format 'YYYY-MM-DDTHH:MM:SS'."
                }, status=status.HTTP_400_BAD_REQUEST)

            if start_date > end_date:
                return Response({
                    "detail": "The 'start' date must be earlier than the 'end' date."
                }, status=status.HTTP_400_BAD_REQUEST)

            tp = params.get('tp')
            at = params.get('at')

            statuses = self.get_status_in_range(
                start_date, end_date, request.user if not request.user.is_staff else None, tp, at)
        elif pk:
            statuses = Status.objects.filter(pk=pk)
        else:
            statuses = Status.objects.all()

        serializer = StatusSerializer(statuses, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = StatusSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        serializer = StatusSerializer(status_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        serializer = StatusSerializer(
            status_instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        status_instance.delete()
        return Response({}, status=status.HTTP_204_NO_CONTENT)


class ReportAPIView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserNotSafe]

    def post(self, request, start_date=None, end_date=None, pk=None):
        if pk:
            report = get_object_or_404(Report, pk=pk)

            report.to_review = True
            report.save()

            return Response({
                "detail": "Report sent to review."
            }, status=status.HTTP_200_OK)

        try:
            start_date = datetime.strptime(start_date, "%Y-%m-%d")
            end_date = datetime.strptime(end_date, "%Y-%m-%d")
            end_date = end_date.replace(hour=23, minute=59, second=59)
        except:
            return Response({
                "detail": "Invalid date format. Please use the format 'YYYY-MM-DD'."
            }, status=status.HTTP_400_BAD_REQUEST)

        params = request.query_params
        if params.get('r') == 't':
            reports = Report.objects.filter(
                Q(start=timezone.make_aware(start_date)) & Q(
                    end=timezone.make_aware(end_date)),
                to_review=False).update(to_review=True)

            return Response({
                "detail": f"Reports sent to review."
            }, status=status.HTTP_200_OK)
        else:
            classes = ClassApiView.get_classes_in_range(
                start_date, end_date)
            vip_status = Status.objects.filter(
                Q(expected__0__lte=timezone.make_aware(end_date)) & Q(
                    expected__1__gte=timezone.make_aware(start_date)),
                Q(kind='vip')
            )

            reports = self.generate_reports(
                classes, vip_status,
                start_date, end_date
            )

            for user_uuid in reports:
                record = Report.objects.filter(
                    user=user_uuid,
                    start=timezone.make_aware(start_date),
                    end=timezone.make_aware(end_date)
                )

                if record.exists():
                    record.delete()

                data = reports[user_uuid]
                data["user"] = user_uuid
                data["start"] = timezone.make_aware(start_date)
                data["end"] = timezone.make_aware(end_date)

                serializer = ReportSerializer(data=data)
                if serializer.is_valid():
                    serializer.save()
                else:
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            return Response({
                "detail": "Reports generated successfully."
            }, status=status.HTTP_201_CREATED)

    def get(self, request, pk=None):
        if pk:
            if request.user.is_staff:
                report = get_object_or_404(Report, pk=pk)
            else:
                report = get_object_or_404(
                    Report, pk=pk, user=request.user, to_review=True)

            serializer = ReportGetSerializer(report)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            if request.user.is_staff:
                params = request.query_params
                if params.get('start') and params.get('end'):
                    try:
                        start = datetime.strptime(
                            params.get('start'), "%Y-%m-%dT%H:%M:%S")
                        end = datetime.strptime(
                            params.get('end'), "%Y-%m-%dT%H:%M:%S")
                    except:
                        return Response({
                            "detail": "Invalid date format. Please use the format 'YYYY-MM-DDTHH:MM:SS'."
                        }, status=status.HTTP_400_BAD_REQUEST)

                    start = timezone.make_aware(start)
                    end = timezone.make_aware(end)

                    reports = Report.objects.filter(start=start, end=end).order_by(
                        '-start', '-end', 'reviewed')
                else:
                    reports = Report.objects.values('start', 'end').annotate(
                        count=Count('*')).order_by('-start', '-end')

                    serializer = ReportPerRangeSerializer(reports, many=True)
                    return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                reports = Report.objects.filter(user=request.user, to_review=True).order_by(
                    '-start', '-end', 'reviewed')

            serializer = ReportRetrieveSerializer(reports, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    def patch(self, request, pk):
        locale.setlocale(locale.LC_TIME, 'pt_BR.UTF-8')

        response_type_check = Response({
            "detail": "Invalid data format. Please use a list of booleans."
        }, status=status.HTTP_400_BAD_REQUEST)

        if not isinstance(request.data.get('toggle'), list):
            return response_type_check

        if not all(isinstance(x, bool) for x in request.data.get('toggle')):
            return response_type_check

        toggle = request.data.get('toggle')
        report = get_object_or_404(Report, pk=pk)

        index = 0
        for day in report.report:
            for sts in day['statuses']:
                if toggle[index]:
                    if sts['type_id'] == 'status':
                        sts_query = Status.objects.get(pk=sts['id'])
                        if sts['entry_report'] and sts['leave_report']:
                            sts_query.register = None
                            sts_query.notes = Status.NOTES[0][0]

                            report.absences += 1
                            report.total_minutes -= (datetime.strptime(sts['leave_report'], "%d/%m/%Y %H:%M") - datetime.strptime(
                                sts['entry_report'], "%d/%m/%Y %H:%M")).total_seconds() // 60
                        elif sts['entry_report']:
                            entry = datetime.strptime(
                                sts['entry_report'], "%d/%m/%Y %H:%M")
                            sts_query.register = [entry.astimezone(
                                timezone.get_current_timezone()), sts_query.expected[1]]
                            sts_query.notes = None

                            report.total_minutes += (sts_query.expected[1] - entry.astimezone(
                                timezone.get_current_timezone())).total_seconds() // 60
                        else:
                            if sts_query.notes == Status.NOTES[0][0]:
                                report.absences -= 1

                            sts_query.notes = None
                            sts_query.register = sts_query.expected

                            report.total_minutes += (
                                sts_query.expected[1] - sts_query.expected[0]).total_seconds() // 60
                        sts_query.save()

                        if sts_query.register:
                            sts['entry_report'] = sts_query.register[0].astimezone(
                                timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M")
                            sts['leave_report'] = sts_query.register[1].astimezone(
                                timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M")
                        else:
                            sts['entry_report'] = None
                            sts['leave_report'] = None
                        sts['comment'] = sts_query.notes
                    else:
                        cls_query = Class.objects.get(pk=sts['id'])

                        date_obj = datetime.strptime(
                            day['date'], "%A, %d de %B de %Y")

                        dates = [
                            datetime.combine(date_obj.date(), cls_query.start_time).astimezone(
                                timezone.get_current_timezone()),
                            datetime.combine(date_obj.date(), cls_query.end_time).astimezone(
                                timezone.get_current_timezone())
                        ]

                        serializer = StatusSerializer(data={
                            "kind": "std",
                            "classy": cls_query.id,
                            "expected": dates,
                            "register": dates
                        })

                        if serializer.is_valid():
                            sts_obj = serializer.save()

                            sts['entry_report'] = dates[0].strftime(
                                "%d/%m/%Y %H:%M")
                            sts['leave_report'] = dates[1].strftime(
                                "%d/%m/%Y %H:%M")
                            sts['comment'] = None
                            sts['id'] = sts_obj.id
                            sts['type_id'] = "status"

                            report.absences -= 1
                            report.total_minutes += (dates[1] -
                                                     dates[0]).total_seconds() // 60

                index += 1
        report.save()

        return Response({
            "detail": "Report updated successfully."
        }, status=status.HTTP_200_OK)

    def generate_reports(self, classes, vip_status, start_date, end_date):
        locale.setlocale(locale.LC_TIME, 'pt_BR.UTF-8')

        report = {}

        def add_to_report_status(user, current_date, status_instance=None, class_instance=None):
            nonlocal absences

            if status_instance:
                report[user.uuid]["report"][-1]["statuses"].append({
                    "id": status_instance.id,
                    "type_id": "status",
                    "class": class_instance.name if class_instance else f"VIP {status_instance.id}",
                    "entry": status_instance.expected[0].astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M"),
                    "leave": status_instance.expected[1].astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M"),
                    "entry_report": status_instance.register[0].astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M") if status_instance.register else None,
                    "leave_report": status_instance.register[1].astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M") if status_instance.register and len(status_instance.register) > 1 else None,
                    "comment": Status.NOTES[0][0] if not status_instance.notes and not status_instance.register else status_instance.notes
                })
            else:
                report[user.uuid]["report"][-1]["statuses"].append({
                    "id": class_instance.id,
                    "type_id": "class",
                    "class": class_instance.name,
                    "entry": (current_date + timedelta(hours=class_instance.start_time.hour, minutes=class_instance.start_time.minute)).astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M"),
                    "leave": (current_date + timedelta(hours=class_instance.end_time.hour, minutes=class_instance.end_time.minute)).astimezone(timezone.get_current_timezone()).strftime("%d/%m/%Y %H:%M"),
                    "entry_report": None,
                    "leave_report": None,
                    "comment": Status.NOTES[0][0]
                })

            if report[user.uuid]["report"][-1]["statuses"][-1]["comment"] == Status.NOTES[0][0]:
                absences += 1

            difference = 0
            if status_instance and status_instance.register and len(status_instance.register) == 2:
                regs = status_instance.register
                difference = (regs[1] - regs[0]).total_seconds() // 60

            return difference

        users = User.objects.all()
        for user in users:
            total_minutes, absences = 0, 0
            classes_user = classes.filter(user=user)
            vip_status_user = vip_status.filter(user=user)

            report[user.uuid] = {"report": []}

            for i in range((end_date - start_date).days + 1):
                current_date = start_date + timedelta(days=i)

                report[user.uuid]["report"].append({
                    "date": current_date.strftime("%A, %d de %B de %Y"),
                    "statuses": []
                })

                for class_instance in classes_user:
                    check = False
                    if weekday(current_date) in class_instance.days:
                        check = True

                    counter = 0
                    for status_instance in class_instance.status.filter(
                            expected__0__gte=timezone.make_aware(current_date),
                            expected__1__lte=timezone.make_aware(
                                current_date + timedelta(days=1)
                            )):
                        total_minutes += add_to_report_status(
                            user,
                            current_date,
                            status_instance, class_instance
                        )
                        counter += 1

                    if check and not counter:
                        total_minutes += add_to_report_status(
                            user,
                            current_date,
                            class_instance=class_instance
                        )

                for vip_status_instance in vip_status_user.filter(
                        expected__0__gte=timezone.make_aware(current_date),
                        expected__1__lte=timezone.make_aware(
                            current_date + timedelta(days=1)
                        )):
                    total_minutes += add_to_report_status(
                        user,
                        current_date,
                        vip_status_instance
                    )

            report[user.uuid]["total_minutes"] = total_minutes
            report[user.uuid]["absences"] = absences

        return report


class ReportReviewAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        report = get_object_or_404(Report, pk=pk)

        if report.user != request.user:
            return Response({
                "detail": "Permission denied."
            }, status=status.HTTP_403_FORBIDDEN)

        report.reviewed = True
        report.save()

        return Response({
            "detail": "Report reviewed successfully."
        }, status=status.HTTP_200_OK)


class NotificationSubscribeAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        request.data["user"] = user.uuid

        serializer = NotificationSubscribeSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            notification = Notification.objects.filter(user=user, endpoint=request.data.get(
                "endpoint"), p256dh=request.data.get("p256dh"), auth=request.data.get("auth"))

            if notification.exists():
                return Response({
                    "detail": "Already subscribed."
                }, status=status.HTTP_201_CREATED)

            serializer.save()

            return Response({
                "detail": "Subscribed successfully."
            }, status=status.HTTP_201_CREATED)

    def delete(self, request):
        user = request.user

        notification = Notification.objects.filter(user=user, endpoint=request.data.get(
            "endpoint"), p256dh=request.data.get("p256dh"), auth=request.data.get("auth"))

        if notification.exists():
            notification.first().delete()

        return Response({}, status=status.HTTP_204_NO_CONTENT)


class NotificationAPIView(APIView):
    permission_classes = [IsAdminUser]

    def post(self, request):
        data = request.data

        notifications = Notification.objects.filter(user=data.get("uuid"))

        users = set()
        counter = 0
        if notifications.exists():
            for notification in notifications:
                try:
                    webpush({
                        "endpoint": notification.endpoint,
                        "keys": {
                            "p256dh": notification.p256dh,
                            "auth": notification.auth
                        }
                    },
                        request.data.get("message"),
                        vapid_private_key="rapRW5SI2Qk_wQNEqtJQY4nN-cuFt91Dp1yKWVfeYIM",
                        vapid_claims={"sub": "mailto:example@gmail.com"},
                        ttl=7200
                    )
                    counter += 1

                    if notification.user not in users:
                        Message.objects.create(
                            user=notification.user,
                            message=request.data.get("message")
                        )
                        users.add(notification.user)

                except WebPushException as ex:
                    if ex.response is not None:
                        if ex.response.status_code == 410:
                            notification.delete()

        if not counter:
            return Response({
                "detail": "No notifications sent."
            }, status=status.HTTP_404_NOT_FOUND)

        return Response({}, status=status.HTTP_200_OK)


class MessageAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        messages = Message.objects.filter(
            user=request.user,
            created_at__gte=timezone.now() - timedelta(hours=12),
            checked=False
        )

        serializer = MessageSerializer(messages, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        pk = request.data.get("pk")

        if not pk:
            return Response({
                "detail": "Missing 'pk' parameter."
            }, status=status.HTTP_400_BAD_REQUEST)

        message = get_object_or_404(Message, pk=pk)

        message.checked = True
        message.save()

        return Response({}, status=status.HTTP_200_OK)
