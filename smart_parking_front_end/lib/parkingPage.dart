import 'package:flutter/material.dart';
import 'ApiService.dart';
import 'models/Parking.dart';
import 'parkingSpots.dart';

class ParkingsPage extends StatefulWidget {
  @override
  _ParkingsPageState createState() => _ParkingsPageState();
}

class _ParkingsPageState extends State<ParkingsPage> {
  late List<Parking> parkings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Parking> data = await ApiService.getParkingList();
      setState(() {
        parkings = data;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Widget _buildParkingList() {
    if (parkings.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: parkings.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: parkings[index].availabilityStatus
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mySpots(parkings[index].id),
                      ),
                    );
                  }
                : null, // Make it null for non-tappable behavior
            child: Card(
              elevation: 5, // Add elevation for a shadow effect
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: parkings[index].availabilityStatus
                  ? null
                  : Colors.grey.withOpacity(
                      0.5), // Adjust opacity for unavailable parking
              child: ListTile(
                contentPadding: EdgeInsets.all(16), // Adjust padding
                leading: Icon(
                  Icons.local_parking,
                  color: Color(0xFFFF6725),
                ),
                title: Text(
                  parkings[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(parkings[index].description),
                trailing: parkings[index].availabilityStatus
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.construction,
                        color: Colors.red,
                      ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6725),
        title: Text('List of Parkings'),
      ),
      body: _buildParkingList(),
    );
  }
}
