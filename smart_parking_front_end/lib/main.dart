import 'package:flutter/material.dart';
import 'package:smart_parking_front_end/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_front_end/ApiService.dart';
import 'package:smart_parking_front_end/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_parking_front_end/notificationPage.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    //runApp(const MainApp());
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
          // Add other providers if needed
        ],
        child: MainApp(),
      ),
    );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 103, 37, 100)
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds and then navigate to the next screen.
    Future.delayed(const Duration(seconds: 2), () {
      bool isLoggedIn =  ApiService.getIsLoggedIn();
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash.png'), // Your splash screen image
      ),
    );
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle FCM messages when the app is in the background or terminated
  String sessionId = message.data['sessionId'];
  //Retrieve the locally stored session ID using shared_preferences or any other storage
  // For example, using shared_preferences package:
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedSessionId = prefs.getString('sessionId') ?? '';

  if (sessionId == storedSessionId) {
    // Handle the notification
    print("Handling a background message: ${message.messageId}");
  }
  //print("Handling a background message: ${message.messageId}");
}

void setupFirebaseMessaging(BuildContext context) {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle FCM messages when the app is in the foreground
    print("Handling a foreground message: ${message.messageId}");
     // Parse the message and create a NotificationItem
    NotificationItem newNotification = NotificationItem.fromJson(message.data);
    Provider.of<NotificationsProvider>(context, listen: false).updateNotifications([newNotification]);
    // Show notifications to the user
    // You can use flutter_local_notifications or other plugins to display notifications
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle FCM messages when the user taps on the notification
    print("Handling a notification when the app is opened: ${message.messageId}");
    // Navigate the user to a specific screen or handle the notification as needed
    print("here");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationsPage()),
    );
  });
}

