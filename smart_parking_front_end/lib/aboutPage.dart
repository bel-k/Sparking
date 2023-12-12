import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Smart Parking'),
        backgroundColor: Color(0xFFFF6725),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Smart Parking!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'What We Do:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6725),
                ),
              ),
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Real-time Parking Availability'),
                subtitle: Text(
                  'Find available parking spaces nearby instantly.',
                ),
              ),
              ListTile(
                leading: Icon(Icons.mobile_screen_share),
                title: Text('Mobile Reservation'),
                subtitle: Text(
                  'Reserve parking spots in advance using your smartphone.',
                ),
              ),
              ListTile(
                leading: Icon(Icons.navigation),
                title: Text('Navigation Assistance'),
                subtitle: Text(
                  'Get directions to your reserved parking spot.',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Why Choose Smart Parking:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6725),
                ),
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text('User-Friendly Interface'),
                subtitle: Text(
                  'Intuitive controls for a hassle-free experience.',
                ),
              ),
              ListTile(
                leading: Icon(Icons.save),
                title: Text('Time and Money Saver'),
                subtitle: Text(
                  'Save time, money, and fuel by avoiding unnecessary searches.',
                ),
              ),
              ListTile(
                leading: Icon(Icons.eco),
                title: Text('Environmentally Friendly'),
                subtitle: Text(
                  'Reduce traffic congestion and emissions associated with parking.',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6725),
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('MorocoSmartParking@gmail.com'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('☎️ 0537587999'),
              ),
              SizedBox(height: 16),
              Text(
                'Join Us on Social Media:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.facebook),
                  Icon(Icons.snapchat),
                  Icon(Icons.telegram),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
