import 'dart:js_util';
import 'package:js/js.dart';

@JS('window.swRegistration')
external Object? get swRegistration;

@JS('window.urlB64ToUint8Array')
external Object? urlB64ToUint8Array(String base64String);

@JS('window.arrayBufferToString')
external String arrayBufferToString(dynamic base64String);

@JS('window.checkSubscription')
external Future<bool> checkSubscription();

Future<dynamic> subscribeUser(String publicKey) async {
  if (swRegistration == null) {
    return;
  }

  var pushManager = getProperty(swRegistration!, 'pushManager');
  var applicationServerKey = urlB64ToUint8Array(publicKey);
  var promise = callMethod(pushManager, 'subscribe', [
    jsify(
      {
        'userVisibleOnly': true,
        'applicationServerKey': applicationServerKey,
      },
    )
  ]);

  var subscription = await promiseToFuture(promise);

  try {
    String endpoint = getProperty(subscription, 'endpoint');
    String key =
        arrayBufferToString(callMethod(subscription, 'getKey', ['p256dh']));
    String auth =
        arrayBufferToString(callMethod(subscription, 'getKey', ['auth']));

    return {
      'endpoint': endpoint,
      'p256dh': key,
      'auth': auth,
    };
  } catch (e) {
    throw Exception('Error when subscribing the user.');
  }
}
