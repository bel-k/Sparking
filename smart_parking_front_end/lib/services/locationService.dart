import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_parking_front_end/models/ParkingLocation.dart';

class LocationService {
  static Future<List<ParkingLocation>?> getNearbyParkings(
      double currentLatitude, double currentLongitude, double diameter) async {
    final response = await http.get(Uri.parse(
        'http://192.168.241.137:8081/api/location/$currentLatitude,$currentLongitude,$diameter/GetNearbyParkings'));
    List<ParkingLocation> parkingLocations = [];
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200) {
        final parkingList = jsonResponse['object'];

        parkingList.forEach((key, value) {
          final location = value['location'];
          final parking = ParkingLocation(
            id: value['id'],
            latitude: location['lat'],
            longitude: location['lon'],
            name: value['name'],
            description: value['description'],
          );
          parkingLocations.add(parking);
        });
        return parkingLocations;
      } else if (jsonResponse['code'] == 401) {
        return parkingLocations;
      }
    } else {
      throw Exception('Failed to load nearby parkings');
    }
  }

  static Future<void> saveLocationSession(
      int sessionId, double latitude, double longitude) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.241.137:8081/api/location/$sessionId,$latitude,$longitude/saveLocationSession'),
    );

    if (response.statusCode == 200) {
      print("its saved");
    } else {
      throw Exception('Failed to save location session');
    }
  }
}
