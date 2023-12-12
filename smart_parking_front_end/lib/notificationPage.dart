import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_front_end/ApiService.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Consumer<NotificationsProvider>(
        builder: (context, notificationsProvider, _) {
          return _buildNotificationsList(context, notificationsProvider);
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _buildNotificationsList(
      BuildContext context, NotificationsProvider notificationsProvider) {
    var notificationsProvider = Provider.of<NotificationsProvider>(context);

    if (notificationsProvider.notifications.isEmpty) {
      return Center(
        child: Text('No notifications'),
      );
    } else {
      notificationsProvider.notifications
          .sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return ListView.builder(
        itemCount: notificationsProvider.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationsProvider.notifications[index];
          return Dismissible(
            key: Key(notification.dateTime.toString()),
            onDismissed: (direction) {
              Provider.of<NotificationsProvider>(context, listen: false)
                  .deleteNotification(index);
            },
            background: Container(
              color: Color(0xFFFF6725),
              child: Icon(Icons.delete, color: Colors.white),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
            ),
            child: Container(
              height: 70,
              color: Colors.grey[50],
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                title: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: Colors.black,
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${notification.title}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          Text(
                            '${notification.message}',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_extractTime(notification.dateTime)}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            '${_formatDate(notification.dateTime)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Handle notification tap
                },
              ),
            ),
          );
        },
      );
    }
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  String _extractTime(String dateTime) {
    return dateTime.substring(11, 19);
  }
}

class NotificationsProvider with ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  int getUnreadNotificationCount() {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  void updateNotifications(List<NotificationItem> newNotifications) {
    _notifications = newNotifications;
    print(
        'in updateNotifications = >notificqtion length =  ${_notifications.length}');
    notifyListeners();
  }

  void updatListNotifications(List<NotificationItem> newNotifications) {
    _notifications = newNotifications;
  }

  void deleteNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  Future<void> markAllAsRead(ApiService apiService) async {
    for (var notification in _notifications) {
      {
        notification.isRead = true;
        apiService.markSessionNotificationAsRead(notification.id);
      }
    }
    notifyListeners();
    print("Marked all notifications as read");
  }
}

class NotificationItem {
  final int id;
  final String dateTime;
  final String title;
  final String message;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.dateTime,
    required this.title,
    required this.message,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
        id: json['id'],
        dateTime: json['dateTime'],
        title: json['notification']['title'],
        message: json['notification']['message'],
        isRead: json['read']);
  }
}
