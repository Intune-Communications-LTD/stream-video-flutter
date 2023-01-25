import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'firebase_options.dart';
import 'src/routes/app_routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _initStreamVideo();
  await _handleRemoteMessage(message);
}

Future<void> _handleRemoteMessage(RemoteMessage message) async {
  print('Handling Remote Message with payload: ${message.data}');
  await StreamVideo.instance.handlePushNotification(message, (call) {
    print('JcLog: on call accepted, ${message.messageId}');
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _initStreamVideo();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  runApp(const StreamDogFoodingApp());
}

void _initStreamVideo() {
  if (!StreamVideo.isInitialized()) {
    StreamVideo.init(
      'us83cfwuhy8n', // see <video>/data/fixtures/apps.yaml for API secret
      coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
          'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
      // 'http://192.168.1.7:26991/rpc',
      coordinatorWsUrl: //replace host with your local ip address
          'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
      // 'ws://192.168.1.7:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    );
  }
}

class StreamDogFoodingApp extends StatelessWidget {
  const StreamDogFoodingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = StreamVideoTheme.light();
    return MaterialApp(
      title: 'Stream Dog Fooding',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        scaffoldBackgroundColor: appTheme.colorTheme.appBg,
        extensions: <ThemeExtension<dynamic>>[
          appTheme,
        ],
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
