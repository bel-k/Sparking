import 'package:flutter/material.dart';
import 'package:smart_parking_front_end/models/Spot.dart';
import 'ApiService.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

final socketUrl =
    'http://192.168.241.137:8081/api/parking-availability/ws-message';

class mySpots extends StatefulWidget {
  final int parkingId; //  field to hold the parking ID
  mySpots(this.parkingId); // Constructor that accepts a parking ID
  @override
  _mySpotsState createState() => _mySpotsState();
}

class _mySpotsState extends State<mySpots> {
  late StompClient stompClient;
  List<Spot> spots = []; // Add this line to hold the list of spots
  Future<void> _loadData() async {
    try {
      List<Spot> data = await ApiService.getParkingSpots(widget.parkingId);
      setState(() {
        spots = data;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  _mySpotsState() {
    _loadData();
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
    _loadData();
    print(' on connect ');
    stompClient.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            List<dynamic> resultList = json.decode(frame.body!);
            List<Spot> updatedSpots =
                resultList.map((e) => Spot.fromJson(e)).toList();

            List<Spot> spotsToAdd = [];

            for (Spot sp in updatedSpots) {
              if (sp.parking.id == widget.parkingId) {
                spotsToAdd.add(sp);
              }
            }

            setState(() {
              spots = spotsToAdd;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    int totalSpots = spots.length;
    int availableSpots = spots.where((spot) => spot.availabilityStatus).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6725),
        title: Text(
          "Available Spots",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'Total Spots $totalSpots/$availableSpots Available Spots',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                for (Spot spot in spots)
                  if (spot.availabilityStatus)
                    Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading:
                            _buildSpotIcon(spot), // Use a separate function
                        title: Text(
                          'Spot Number : ${spot.number}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Price: ${spot.price}'),
                        onTap: () {
                          // Add onTap functionality if needed
                        },
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Icon _buildSpotIcon(Spot spot) {
    // Add logic to determine which icon to display
    if (spot.vehicleType == 'car') {
      return Icon(Icons.directions_car, color: Color(0xFFFF6725));
    } else if (spot.vehicleType == 'motorcycle') {
      return Icon(Icons.motorcycle, color: Color(0xFFFF6725));
    } else if (spot.vehicleType == 'bike') {
      return Icon(Icons.directions_bike, color: Color(0xFFFF6725));
    } else if (spot.disabled) {
      return Icon(Icons.accessible_sharp, color: Color(0xFFFF6725));
    } else {
      // Default icon if none of the conditions are met
      return Icon(Icons.directions_walk, color: Color(0xFFFF6725));
    }
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (stompClient != null) {
      stompClient.deactivate();
    }

    super.dispose();
  }
}
