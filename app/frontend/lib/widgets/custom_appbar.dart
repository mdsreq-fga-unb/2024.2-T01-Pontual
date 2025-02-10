import 'package:flutter/material.dart';
import 'package:frontend/api/message_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String page;

  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    required this.title,
    required this.page,
  }) : preferredSize = const Size.fromHeight(110);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<dynamic> notifications = [];

  void popUpNotification() {
    MessageHandler()
        .get(context.read<UserProvider>().accessToken)
        .then((value) {
      setState(() {
        notifications = value;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Notificações'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < notifications.length; i++)
                  GestureDetector(
                    onTap: () {
                      MessageHandler()
                          .post(
                        context.read<UserProvider>().accessToken,
                        notifications[i]['id'],
                      )
                          .then((_) {
                        popUpNotification();
                        Navigator.of(context).pop();
                      }).catchError((error) {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: i % 2 == 0 ? Colors.grey[200] : Colors.grey[100],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(notifications[i]['message']),
                              SizedBox(width: 15),
                              Icon(
                                Icons.close,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();

    MessageHandler()
        .get(context.read<UserProvider>().accessToken)
        .then((value) {
      setState(() {
        notifications = value;
      });
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF08484),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.page,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                context.read<UserProvider>().isAdmin
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          popUpNotification();
                        },
                        icon: Stack(
                          clipBehavior: Clip
                              .none, // Allows the badge to overflow outside the Stack
                          children: [
                            const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 30, // Adjust size if needed
                            ),
                            if (notifications
                                .isNotEmpty) // Only show the red dot if haveNotification is true
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      4), // Adjust padding for size
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
