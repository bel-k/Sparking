import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_front_end/home.dart';
import 'register.dart'; // Import the RegisterPage widget
import 'ApiService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String storedSessionId;
  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedSessionId = prefs.getString('sessionId') ?? '';
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs().then((_) {
      if (storedSessionId.isNotEmpty) {
        _init();
      }
    });
    // storedSessionId = "";
    // getSharedPrefs();
    // print("i'm logged in and this is my session id "+storedSessionId);
    // _subscribeToTopic(storedSessionId);
  }

  Future<void> _init() async {
    await getSharedPrefs();
    print("I'm logged in, and this is my session id $storedSessionId");

    if (storedSessionId.isNotEmpty) {
      await _subscribeToTopic(storedSessionId);
    }
  }

  Future<void> _subscribeToTopic(String sessionId) async {
    await _firebaseMessaging.subscribeToTopic(sessionId);
    print('Subscribed to FCM topic: $sessionId');
  }

  bool passwordHidden = true;
  void _togglePasswordVisibility() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double topPadding = screenHeight * 0.1;
    double horizontalPadding = screenWidth * 0.06;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset(
                'assets/splash.png', // Replace this with your app's logo
                height: 100,
                width: 100,
              ),
              SizedBox(height: 10),
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish', // Mulish font family
                ),
              ),
              SizedBox(height: 0),
              Text(
                'Sign in to access your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Mulish',
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              // Email TextField
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: _emailLabelColor),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.email,
                    color: _emailIconColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6725)),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Mulish', // Mulish font family
                ),
                onTap: () {
                  setState(() {
                    // Change label text color to orange when the field is tapped
                    _emailLabelColor = Color(0xFFFF6725);
                    // Change icon color to orange when the field is tapped
                    _emailIconColor = Color(0xFFFF6725);
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    _emailLabelColor = Colors.grey;
                    _emailIconColor = Colors.grey;
                  });
                },
              ),
              SizedBox(height: 10),
              // Password TextField
              TextFormField(
                controller: _passwordController,
                obscureText: passwordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: _passwordLabelColor),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _togglePasswordVisibility();
                    },
                    icon: Icon(
                      passwordHidden ? Icons.visibility : Icons.visibility_off,
                      color: _passwordIconColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6725)),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Mulish', // Mulish font family
                ),
                onTap: () {
                  setState(() {
                    _passwordLabelColor = Color(0xFFFF6725);
                    _passwordIconColor = Color(0xFFFF6725);
                  });
                },
              ),
              SizedBox(height: 0),
              // Remember me and Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: _isRememberMeChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isRememberMeChecked = value ?? false;
                          });
                        },
                        activeColor: Color(0xFFFF6725),
                        visualDensity:
                            VisualDensity(vertical: -2, horizontal: -2),
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontFamily: 'Mulish', // Mulish font family
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontFamily: 'Mulish', // Mulish font family
                          color: Color(0xFFFF6725)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              // Sign In Button
              ElevatedButton(
                onPressed: _handleSignIn,
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontFamily: 'Mulish', // Mulish font family
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(300, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF6725)),
                ),
              ),
              SizedBox(height: 10),
              // Register Text
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'New Member?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      TextSpan(
                        text: ' Register now',
                        style: TextStyle(
                          color: Color(0xFFFF6725),
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  bool _isRememberMeChecked = false;
  Color _emailLabelColor = Colors.grey;
  Color _emailIconColor = Colors.grey;
  Color _passwordLabelColor = Colors.grey;
  Color _passwordIconColor = Colors.grey;

  void _handleSignIn() async {
    print('Attempting to sign in');
    // Extract email and password from TextFormField
    String email = _emailController.text;
    String password = _passwordController.text;

    // Prepare the request data
    Map<String, dynamic> request = {
      'login': email,
      'password': password,
    };
    try {
      Map<String, dynamic> response = await ApiService.signIn(request);
      print('Sign in response: $response');
      if (response.containsKey('token') && response.containsKey('sessionId')) {
        var s = response['sessionId'];
        String sessionId = '$s';
        print("i got session id " + sessionId);

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('sessionId', sessionId);
        });
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await http.post(
            Uri.parse(
                'http://192.168.241.137:8081/api/real-time-notifications/register'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'token': token, 'sessionId': sessionId}),
          );
        }
        // Navigate to the home page after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace HomePage() with the actual widget for your home page
        );
      } else {
        // Handle unsuccessful sign-in here if needed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign in. Please try again.......'),
        ));
      }
    } catch (error) {
      print('Error occurred during sign in: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in. Please try again.'),
      ));
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
