import 'package:flutter/material.dart';
import 'package:smart_parking_front_end/mapLocation.dart';
import 'notificationPage.dart';
import 'aboutPage.dart';
import 'package:smart_parking_front_end/parkingPage.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_front_end/ApiService.dart';
import 'package:smart_parking_front_end/login.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

final socketUrl =
    'http://192.168.241.137:8081/api/real-time-notifications/ws-message';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;
  List<NotificationItem> notifications = [];
  late String storedSessionId;
  late NotificationsProvider notificationsProvider;
  final ApiService apiService = ApiService();
  List<NotificationItem> fetchedNotifications = [];
  int unreadCount = 0;
  late StompClient stompClient;

  _HomePageState() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient.activate();
  }
  void onConnect(StompFrame frame) {
    if (mounted) {
      print(' on connect ');
      stompClient.subscribe(
          destination: '/topic/message',
          callback: (StompFrame frame) {
            if (frame.body != null) {
              var jsonResult = json.decode(frame.body!);
              NotificationItem newNotification =
                  NotificationItem.fromJson(jsonResult);
              fetchedNotifications.add(newNotification);
              Provider.of<NotificationsProvider>(context, listen: false)
                  .updateNotifications(fetchedNotifications);
              int newUnreadCount =
                  notificationsProvider.getUnreadNotificationCount();
              setState(() {
                unreadCount = newUnreadCount;
              });
            }
          });
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storedSessionId = prefs.getString('sessionId') ?? '';
      fetchedNotifications = await ApiService.getNotifications(storedSessionId);
      print("Fetched notifications: $fetchedNotifications");
      print(
          'in _fetchNotifications = >notificqtion length =  ${fetchedNotifications.length}');
      if (mounted) {
        Provider.of<NotificationsProvider>(context, listen: false)
            .updateNotifications(fetchedNotifications);
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      MapLocation(),
      NotificationsPage(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
    notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    _fetchNotifications();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedPageIndex == 0 ? Text('Home') : Text('Notifications'),
        backgroundColor: Color(0xFFFF6725),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: _selectedPageIndex == 0
                ? Stack(
                    children: [
                      Icon(Icons.notifications),
                      if (notificationsProvider.getUnreadNotificationCount() >
                          0)
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${notificationsProvider.getUnreadNotificationCount()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
                : Icon(Icons.location_on_sharp),
            onPressed: () {
              setState(() {
                _selectedPageIndex = _selectedPageIndex == 0 ? 1 : 0;
                _pageController.jumpToPage(_selectedPageIndex);
              });
              if (_selectedPageIndex == 0) {
                Provider.of<NotificationsProvider>(context, listen: false)
                    .markAllAsRead(apiService);
                setState(() {
                  unreadCount = 0;
                });
              }
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  'user@email.com',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6725),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('My Information'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => UserInformationPage(),
                  //   ),
                  // );
                },
                tileColor: Colors.transparent,
                hoverColor: Colors.grey.withOpacity(0.1),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutPage(), // Create AboutPage widget
                    ),
                  );
                },
                tileColor: Colors.transparent,
                hoverColor: Colors.grey.withOpacity(0.1),
              ),
              ListTile(
                leading: Icon(Icons.local_parking_outlined),
                title: Text('Parking List'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingsPage(),
                    ),
                  );
                },
                tileColor: Colors.transparent,
                hoverColor: Colors.grey.withOpacity(0.1),
              ),
              Divider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //_buildCar(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () async {
                        await apiService.logoutRequest();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      tileColor: Colors.transparent,
                      hoverColor: Colors.grey.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
