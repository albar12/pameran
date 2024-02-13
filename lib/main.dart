import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/laporan_pemasangan/laporan_pemasangan.dart';
import 'package:jadin_pameran/login/login_page.dart';
import 'package:jadin_pameran/model/notificationservice.dart';
import 'package:jadin_pameran/model/shared_preferances.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.data}");
//   NotificationService.showBigTextNotification(1,
//       title: (message.data['title'] != null
//           ? message.data['title']
//           : "title kosong"),
//       body: (message.data['message'] != null
//           ? message.data['message']
//           : "message kosong"),
//       fln: flutterLocalNotificationsPlugin);
// }

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // NotificationService.initialize(flutterLocalNotificationsPlugin);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // FirebaseMessaging.onBackgroundMessage((message) async {
  // //   print(message.data);
  // // });
  // messaging.getToken().then((value) {
  //   print("token : ${value}");
  // });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');
//     NotificationService.showBigTextNotification(1,
//         title: (message.data['title'] != null
//             ? message.data['title']
//             : "title kosong"),
//         body: (message.data['message'] != null
//             ? message.data['message']
//             : "message kosong"),
//         fln: flutterLocalNotificationsPlugin);

// // LaporanPemasanganPage()
//     messaging.setForegroundNotificationPresentationOptions(
//         alert: true, badge: true, sound: true);

//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.notification}');
//     }
//   });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const CekLogin(),
    );
  }
}

class CekLogin extends StatefulWidget {
  const CekLogin({super.key});

  @override
  State<CekLogin> createState() => _CekLoginState();
}

class _CekLoginState extends State<CekLogin> {
  String? session_login;
  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cek_login();
  }

  @override
  Widget build(BuildContext context) {
    print("${session_login} + login");
    return session_login != "null" ? HomePage() : LoginPage();
    // return LoginPage();
  }

  cek_login() async {
    String? tes = await SharedPref.getString('session');
    if (tes != null) {
      setState(() {
        session_login = tes;
      });
    }
  }
}
