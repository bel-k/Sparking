import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_front_end/notificationPage.dart';
import 'package:smart_parking_front_end/models/Parking.dart';
import 'package:smart_parking_front_end/models/Spot.dart';

class ApiService {
  static bool isLoggedIn = false;
  static const String baseUrl = "http://192.168.241.137:8081/api"; //10.0.2.2
  static const String parkingSpotsUrl =
      "$baseUrl/parking-availability/spot/findSpotInParking"; //10.0.2.2
  static const String parkingsUrl = "$baseUrl/parking-availability/parking";
  static const String spotUrl = "$baseUrl/parking-availability/spot";

  static Future<Map<String, dynamic>> signUp(
      Map<String, dynamic> request) async {
    print(request);
    final response = await http.post(
      Uri.parse('$baseUrl/user-management/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request),
    );
    print(response);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to sign up');
    }
  }

  static bool getIsLoggedIn() {
    return isLoggedIn;
  }

  static Future<Map<String, dynamic>> signIn(
      Map<String, dynamic> request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user-management/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request),
    );
    if (response.statusCode == 200) {
      isLoggedIn = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', json.decode(response.body)['token']);
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to sign in.......');
    }
  }

  Future<void> logoutRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('authToken') ?? '';
    final response = await http.post(
        Uri.parse('$baseUrl/user-management/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print(response);
    if (response.statusCode == 200) {
      await prefs.remove('authToken');
      isLoggedIn = false;
      print('Logout successful');
    } else {
      // Print the response body for more details
      print('Logout failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  static Future<List<NotificationItem>> getNotifications(
      String sessionId) async {
    final url =
        Uri.parse('$baseUrl/real-time-notifications/$sessionId/notifications');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      List<NotificationItem> notifications =
          jsonList.map((e) => NotificationItem.fromJson(e)).toList();
      return notifications;
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markSessionNotificationAsRead(int sessionNotificationId) async {
    final String apiUrl =
        '$baseUrl/real-time-notifications/$sessionNotificationId/mark-as-read';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'sessionNotificationId': sessionNotificationId.toString()},
      );

      if (response.statusCode == 200) {
        print('Marked as read successfully');
      } else {
        print('Failed to mark as read. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  static Future<List<Parking>> getParkingList() async {
    var response = await http.get(Uri.parse('$parkingsUrl'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Parking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Parkings');
    }
  }

  static Future<List<Spot>> getParkingSpots(int parkingId) async {
    var response = await http.get(Uri.parse('$parkingSpotsUrl/$parkingId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Spot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Spot');
    }
  }

  static Future<List<Spot>> getSpotList() async {
    var response = await http.get(Uri.parse('$spotUrl'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Spot list :${data.length}');
      return data.map((json) => Spot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Spots');
    }
  }
}
