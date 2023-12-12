import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_front_end/ApiService.dart';
import 'package:smart_parking_front_end/home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordHidden = true;
  void _togglePasswordVisibility() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  bool isDisabled = false;
  var items = ['Car', 'Motor'];
  late String dropdownValue;
  @override
  void initState() {
    super.initState();
    //dropdownValue = items.first;
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue = items.first;
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
                'Get Started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish', // Mulish font family
                ),
              ),
              SizedBox(height: 0),
              Text(
                'by creating a free account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Mulish',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                focusNode: _fullnameFocusNode,
                controller: _fullnameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  labelStyle: TextStyle(color: _fullnameColor),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.person,
                    color: _fullnameColor,
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
                    _fullnameColor = Color(0xFFFF6725);
                    // // Change icon color to orange when the field is tapped
                    // _emailIconColor = Color(0xFFFF6725);
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    _emailLabelColor = Colors.grey;
                    _emailIconColor = Colors.grey;
                  });
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                controller: _emailController,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 10.0),
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
              SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.phone,
                focusNode: _phonenumberFocusNode,
                controller: _phoneController,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 10.0),
                  labelText: 'Phone number',
                  labelStyle: TextStyle(color: _phonenumberColor),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.phone,
                    color: _phonenumberColor,
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
                    _phonenumberColor = Color(0xFFFF6725);
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    _emailLabelColor = Colors.grey;
                    _emailIconColor = Colors.grey;
                    _fullnameColor = Colors.grey;
                    _phonenumberColor = Colors.grey;
                  });
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                obscureText: passwordHidden,
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 10.0),
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
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Focus(
                      focusNode: _diabledFocusNode,
                      child: Text(
                        'Are you a disabled person?',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Yes',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                        Radio(
                          value: true,
                          groupValue: isDisabled,
                          activeColor: Color(0xFFFF6725),
                          onChanged: (value) {
                            setState(() {
                              isDisabled = value as bool;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'No',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                        Radio(
                          value: false,
                          groupValue: isDisabled,
                          activeColor: Color(0xFFFF6725),
                          onChanged: (value) {
                            setState(() {
                              isDisabled = value as bool;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: _vehicleTypeFocusNode.hasFocus
                        ? Color(0xFFFF6725)
                        : Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Select Vehicle Type:',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 115.0),
                    DropdownButton(
                      key: UniqueKey(),
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.grey),
                      items: items.map((itemone) {
                        return DropdownMenuItem(
                            value: itemone, child: Text(itemone));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
              // Remember me and Forgot password
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //  // context,
                  //   //MaterialPageRoute(builder: (context) => LoginPage()),
                  // );
                },
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      activeColor: Color(0xFFFF6725),
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ??
                              false; // Update the state of the checkbox
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'By checking the box you agree to our',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          TextSpan(
                            text: ' Terms',
                            style: TextStyle(
                              color: Color(0xFFFF6725),
                              fontSize: 10,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          TextSpan(
                            text: ' and',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          TextSpan(
                            text: ' Conditions',
                            style: TextStyle(
                              color: Color(0xFFFF6725),
                              fontSize: 10,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Sign In Button
              ElevatedButton(
                onPressed: _handleSignUP,
                child: Text(
                  'Sign up',
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already a Member?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      TextSpan(
                        text: ' Log in',
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
  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _phonenumberFocusNode = FocusNode();
  FocusNode _diabledFocusNode = FocusNode();
  FocusNode _vehicleTypeFocusNode = FocusNode();
  bool _isChecked = false;
  Color _emailLabelColor = Colors.grey;
  Color _emailIconColor = Colors.grey;
  Color _passwordLabelColor = Colors.grey;
  Color _passwordIconColor = Colors.grey;
  Color _fullnameColor = Colors.grey;
  Color _phonenumberColor = Colors.grey;
  Color _disabledColor = Colors.grey;
  void _handleSignUP() async {
    print('Attempting to sign un');
    // Extract email and password from TextFormField
    String email = _emailController.text;
    String password = _passwordController.text;
    String fullname = _fullnameController.text;
    String phonenumber = _phoneController.text;
    // Prepare the request data
    Map<String, dynamic> request = {
      'email': email,
      'password': password,
      'user': {
        'firstName': fullname,
        'lastName': fullname,
        'email': email,
        'phoneNumber': phonenumber,
        'disabled': isDisabled,
        'vehicleType': dropdownValue,
      },
    };
    try {
      Map<String, dynamic> response = await ApiService.signUp(request);
      print('Sign up response: $response');
      if (response.containsKey('token')) {
        // Registration was successful, now perform automatic sign-in
        Map<String, dynamic> signInRequest = {
          'login': email,
          'password': password,
        };

        // Make the sign-in API call
        Map<String, dynamic> signInResponse =
            await ApiService.signIn(signInRequest);
        if (signInResponse.containsKey('token') &&
            signInResponse.containsKey('sessionId')) {
          var s = signInResponse['sessionId'];
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
      } else {
        // Handle unsuccessful registration here if needed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign up. Please try again.'),
        ));
      }
    } catch (error) {
      print('Error occurred during sign in: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign up. Please try again.'),
      ));
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _phonenumberFocusNode.dispose();
    super.dispose();
  }
}
