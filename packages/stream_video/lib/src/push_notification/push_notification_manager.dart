import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../call/call.dart';
import '../models/call_configuration.dart';
import '../stream_video.dart';
import 'call_notification_wrapper.dart';

class PushNotificationManager {
  PushNotificationManager({
    required StreamVideo client,
    CallNotificationWrapper callNotification = const CallNotificationWrapper(),
  })  : _client = client,
        _callNotification = callNotification;

  final StreamVideo _client;
  final CallNotificationWrapper _callNotification;

  Future<void> onUserLoggedIn() async {
    print('JcLog: [onUserLoggedIn]');
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _registerFirebaseToken(token);
      } else {
        print('JcLog: Firebase Token was null');
      }
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    print('JcLog: New Firebase Token: $token');
    await _client.createDevice(token: token);
  }

  Future<bool> handlePushNotification(
    RemoteMessage remoteMessage,
    void Function(Call call) onCallAccepted,
  ) async {
    if (_isValid(remoteMessage)) {
      final cid = remoteMessage.data['call_cid'] as String;
      final type = cid.substring(0, cid.indexOf(':'));
      final id = cid.substring(cid.indexOf(':') + 1);
      // final call = await _client.getOrCreateCall(type: type, id: id);
      await _callNotification.showCallNotification(
        callId: cid,
        callers: 'Jc, Isa', //call.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: '', //call.users.values.firstOrNull?.imageUrl,
        onCallAccepted: (cid) async {
          onCallAccepted(
            Call(
              callConfiguration: const CallConfiguration(
                type: 'type',
                id: 'id',
                participantIds: ['jc', 'isa'],
              ),
            ),
          );
        },
        onCallRejected: _rejectCall,
      );
      return true;
    }
    return false;
  }

  Future<Call> _acceptCall(String cid) {
    return _client.acceptCall(
      type: cid.substring(0, cid.indexOf(':')),
      id: cid.substring(cid.indexOf(':') + 1),
    );
  }

  Future<void> _rejectCall(String cid) async {
    await _client.rejectCall(callCid: cid);
  }

  bool _isValid(RemoteMessage remoteMessage) {
    return _isFromStreamServer(remoteMessage) &&
        _isValidIncomingCall(remoteMessage);
  }

  bool _isFromStreamServer(RemoteMessage remoteMessage) {
    return remoteMessage.data['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(RemoteMessage remoteMessage) {
    return remoteMessage.data['type'] == 'call_incoming' &&
        ((remoteMessage.data['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }
}