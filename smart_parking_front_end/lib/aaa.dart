// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// import 'package:label_marker/label_marker.dart';
// import 'package:smart_parking_front_end/ApiService.dart';
// import 'package:smart_parking_front_end/models/ParkingLocation.dart';
// import 'package:smart_parking_front_end/models/Spot.dart';
// import 'package:smart_parking_front_end/services/locationService.dart';
// import 'parkingSpots.dart';
// import 'dart:convert';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';

// final socketUrl =
//     'http://192.168.241.137:8081/api/parking-availability/ws-message';

// class MapLocation extends StatefulWidget {
//   const MapLocation({Key? key}) : super(key: key);

//   @override
//   _MapLocationState createState() => _MapLocationState();
// }

// class _MapLocationState extends State<MapLocation> {
//   late GoogleMapController googleMapController;
//   static const CameraPosition initialCameraPosition = CameraPosition(
//       target: LatLng(33.692482261905276, -7.392397616039303), zoom: 14);
//   Set<Marker> markers = {};
//   late Timer locationUpdateTimer;
//   late BitmapDescriptor arrowIcon;
//   late BitmapDescriptor ParkingIcon;
//   bool firstCamera = false;
//   double currentZoom = 14.0; // Initial zoom level
//   CameraPosition? lastCameraPosition; // Store the last camera position
// //  List<ParkingLocation> parkingLocations = [];
//   Set<Marker> customMarkers = {};
//   Set<Polyline> polylines = {}; // Store polylines here
//   late PolylinePoints polylinePoints;
//   TextEditingController radiusController = TextEditingController();
//   late double diametre = 100000.0;

// // Declare a 2D matrix of integers with a fixed number of rows, initially filled with null
//   List<List<int?>> matrix = List.generate(
//     20,
//     (index) => List<int?>.filled(
//         2, 0), // Assuming each row has2 columns, filled with null
//   );
//   late StompClient stompClient;
//   List<Spot> spots = []; //
//   _MapLocationState() {
//     print(' _MapLocationState 1');
//     _loadData();
//     print(' _MapLocationState 2     ');
//     stompClient = StompClient(
//       config: StompConfig.sockJS(
//         url: socketUrl,
//         onConnect: onConnect,
//         onWebSocketError: (dynamic error) => print(error.toString()),
//       ),
//     );
//     stompClient.activate();
//   }
//   void onConnect(StompFrame frame) async {
//     print(' on connect location1 ');
//     await _loadData(); // Move the asynchronous work outside setState

//     print(' on connect location');
//     stompClient.subscribe(
//       destination: '/topic/message',
//       callback: (StompFrame frame) async {
//         if (frame.body != null) {
//           print("inside frame");
//           List<dynamic> resultList = json.decode(frame.body!);
//           List<Spot> updatedSpots =
//               resultList.map((e) => Spot.fromJson(e)).toList();
//           print('inside frame list lenght : ${updatedSpots.length}');
//           List<List<int?>> matrixUpdated = List.generate(
//             20,
//             (index) => List<int?>.filled(2, 0),
//           );
//           for (Spot sp in updatedSpots) {
//             matrixUpdated[sp.parking.id][0] =
//                 matrixUpdated[sp.parking.id][0]! + 1;
//             print('   ${sp.spotId}    : ${sp.availabilityStatus}');
//             print(
//                 'inside for : parking : ${sp.parking.id}: ${matrixUpdated[sp.parking.id][0]} spot total');
//             if (sp.availabilityStatus == true)
//               matrixUpdated[sp.parking.id][1] =
//                   matrixUpdated[sp.parking.id][1]! + 1;
//             print(
//                 'inside for : parking : ${sp.parking.id}: ${matrixUpdated[sp.parking.id][1]} spot free');
//           }

//           // // Move the setState inside an async function
//           _updateMatrix(matrixUpdated);

//           // setState(() {
//           //   matrix = matrixUpdated;
//           // });
//         }
//       },
//     );
//   }

// // Add this method to update the state inside setState
//   void _updateMatrix(List<List<int?>> matrixUpdated) {
//     setState(() {
//       matrix = matrixUpdated;
//     });
//   }

//   Future<void> _loadData() async {
//     print("loading data matrix ");
//     try {
//       List<Spot> data = await ApiService.getSpotList();
//       spots = data;
//       List<List<int?>> matrixUpdated = List.generate(
//         20,
//         (index) => List<int?>.filled(2, 0),
//       );
//       for (Spot sp in spots) {
//         matrixUpdated[sp.parking.id][0] = matrixUpdated[sp.parking.id][0]! + 1;
//         if (sp.availabilityStatus)
//           matrixUpdated[sp.parking.id][1] =
//               matrixUpdated[sp.parking.id][1]! + 1;
//       }
//       // Call the async function to update the state
//       _updateMatrix(matrixUpdated);
//     } catch (e) {
//       print('Error loading data: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     polylinePoints = PolylinePoints();
//     locationUpdateTimer =
//         Timer.periodic(const Duration(seconds: 5000000), (timer) {
//       _updateUserLocation();
//     });

//     // Load the custom arrow icon
//     _loadCustomArrowIcon();
//   }

//   @override
//   void dispose() {
//     locationUpdateTimer
//         .cancel(); //comment if u wanna activate the real time location
//     // stompClient.deactivate(); // Add this line to deactivate the Stomp client
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Positioned.fill(
//             child: GoogleMap(
//               initialCameraPosition: initialCameraPosition,
//               markers: markers,
//               polylines: polylines, // Set the polylines
//               zoomControlsEnabled: false,
//               mapType: MapType.normal,
//               onMapCreated: (GoogleMapController controller) {
//                 googleMapController = controller;
//               },
//               onCameraMove: (CameraPosition position) {
//                 lastCameraPosition = position; // Update last camera position
//               },
//               mapToolbarEnabled: false,
//             ),
//           ),
//           Positioned(
//             bottom: 10.0,
//             left: 10.0,
//             right: 10.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 FloatingActionButton(
//                   heroTag: "btn1",
//                   onPressed: () {
//                     firstCamera = false;
//                     _updateUserLocation();
//                   },
//                   backgroundColor: Color.fromARGB(255, 194, 81, 6),
//                   child: const Icon(Icons.location_on_outlined),
//                 ),
//                 SizedBox(width: 16),
//                 // FloatingActionButton(
//                 //   onPressed: () async {
//                 //     Position position = await _determinePosition();
//                 //   },
//                 //   backgroundColor: const Color.fromARGB(
//                 //       255, 194, 81, 6), // Change the color as needed
//                 //   child: Icon(Icons.search),
//                 // ),
//                 // SizedBox(width: 16),
//                 FloatingActionButton(
//                   heroTag: "btn2",
//                   onPressed: () {
//                     _showRadiusInputDialog();
//                   },
//                   backgroundColor: Color.fromARGB(
//                       255, 194, 81, 6), // Change the color as needed
//                   child: Icon(Icons.radio_button_on_sharp),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRadiusInputDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Radius (in km)'),
//           content: TextField(
//             controller: radiusController,
//             keyboardType: TextInputType.number,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             decoration: InputDecoration(labelText: 'Radius'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 double radius = double.tryParse(radiusController.text) ?? 0.0;
//                 if (radius > 0) {
//                   diametre = radius;
//                   _updateUserLocation();
//                   Navigator.of(context).pop(); // Close the dialog
//                 } else {
//                   // Show an error message or handle invalid input
//                 }
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _loadCustomArrowIcon() async {
//     arrowIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, 'assets/arrow_icon.png');
//     ParkingIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, 'assets/park.png');
//   }

//   Future<void> _updateUserLocation() async {
//     try {
//       Position position = await _determinePosition();
//       LatLng currentTarget;
//       CameraPosition newCameraPosition =
//           lastCameraPosition ?? initialCameraPosition;
//       if (firstCamera == true) {
//         currentTarget = newCameraPosition.target;
//       } else {
//         currentTarget = LatLng(position.latitude, position.longitude);
//       }
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: currentTarget,
//             zoom: newCameraPosition.zoom, // Use the stored zoom level
//           ),
//         ),
//       );

//       // Clear existing markers and polylines
//       markers.clear();

//       // Add marker for user's location
//       markers.add(Marker(
//         markerId: const MarkerId('currentLocation'),
//         position: LatLng(position.latitude, position.longitude),
//         icon: arrowIcon,
//         rotation: position.heading,
//       ));
//       firstCamera = true;

//       double currentLatitude = position.latitude;
//       double currentLongitude = position.longitude;

//       List<ParkingLocation> nearbyParkings =
//           await LocationService.getNearbyParkings(
//         currentLatitude,
//         currentLongitude,
//         diametre,
//       );

//       // Perform asynchronous work outside setState

//       updateParkingMarkers(nearbyParkings);

//       // Update the state synchronously inside setState
//       setState(() {});
//     } catch (e) {
//       print('Error fetching nearby parkings: $e');
//     }
//   }

//   Future<Position> _determinePosition() async {
//     PermissionStatus status = await Permission.location.status;

//     if (status.isDenied) {
//       status = await Permission.location.request();

//       if (status.isDenied) {
//         return Future.error("Location permission denied");
//       }
//     }

//     if (status.isPermanentlyDenied) {
//       openAppSettings();
//       return Future.error('Location permissions are permanently denied');
//     }

//     if (status.isGranted) {
//       Position position = await Geolocator.getCurrentPosition();
//       await LocationService.saveLocationSession(
//           12, position.latitude, position.longitude);
//       return position;
//     }

//     return Future.error('Location services are disabled');
//   }

//   void updateParkingMarkers(List<ParkingLocation> parkingLocations) async {
//     // Clear existing parking markers
//     markers.removeWhere((marker) => marker.icon == ParkingIcon);
//     markers.removeWhere((marker) => marker.anchor == const Offset(0.5, 1.6));

//     // Create a list to store the results of asynchronous operations
//     List<Future> asyncOperations = [];

//     // Add parking markers
//     for (var parkingLocation in parkingLocations) {
//       int totalSpots = matrix[parkingLocation.id][0] ?? 0;
//       int freeSpots = matrix[parkingLocation.id][1] ?? 0;
//       markers.add(Marker(
//           markerId: MarkerId(parkingLocation.name),
//           position: LatLng(parkingLocation.latitude, parkingLocation.longitude),
//           icon: ParkingIcon,
//           onTap: () {
//             // Handle the tap on the InfoWindow
//             _handleInfoWindowTap(parkingLocation);
//           }));

//       // Perform asynchronous operation and store the result
//       Future asyncOperation = markers.addLabelMarker(LabelMarker(
//         label: '$freeSpots / $totalSpots Free Spots',
//         anchor: const Offset(0.5, 1.6),
//         markerId: MarkerId(parkingLocation.name + 'spots'),
//         position: LatLng(parkingLocation.latitude, parkingLocation.longitude),
//         backgroundColor: Color.fromARGB(149, 254, 119, 46),
//       ));

//       // Add the future to the list
//       asyncOperations.add(asyncOperation);
//     }

//     // Wait for all asynchronous operations to complete
//     await Future.wait(asyncOperations);

//     // Update the state synchronously inside setState
//     setState(() {});
//   }

//   void _handleInfoWindowTap(ParkingLocation parkingLocation) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor:
//               Color.fromARGB(219, 234, 225, 212), // Set the background color
//           title: Center(child: Text(parkingLocation.name)), // Center the title
//           content: Text(parkingLocation.description),
//           actions: <Widget>[
//             FloatingActionButton(
//               heroTag: "btn3",
//               child: const Icon(Icons.directions),
//               backgroundColor: Color.fromARGB(255, 194, 81, 6),
//               onPressed: () {
//                 print("Draw Route icon clicked");
//                 _drawRouteToParking(
//                     parkingLocation.latitude, parkingLocation.longitude);
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             FloatingActionButton(
//               heroTag: "btn4",
//               child: const Icon(Icons.info),
//               backgroundColor: Color.fromARGB(255, 194, 81, 6),
//               onPressed: () {
//                 //INFO ABOUT PARKING
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => mySpots(parkingLocation.id),
//                   ),
//                 );
//                 //  Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _drawRouteToParking(
//       double destinationLatitude, double destinationLongitude) async {
//     // Get the current user's location
//     print("m being called");
//     Position userLocation = await _determinePosition();

//     // Set up the polyline request
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyAhcJr7vuC1Fo00wZTMH0XNi1RzHUMsht4", //api b flous
//       //"AIzaSyAoYyVtCgTYVqecQtSbfjfODJopWuKRg7k",   //api bla flous
//       PointLatLng(userLocation.latitude, userLocation.longitude),
//       PointLatLng(destinationLatitude, destinationLongitude),
//       travelMode: TravelMode.driving,
//     );

//     // Extract the polyline points
//     List<LatLng> polylineCoordinates = result.points
//         .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
//         .toList();

//     print(
//         "Polyline Coordinates: $polylineCoordinates"); // Add this line to print the coordinates

//     setState(() {
//       // Clear existing polylines
//       polylines.clear();

//       // Add the new polyline
//       polylines.add(Polyline(
//         polylineId: PolylineId('route_to_parking'),
//         points: polylineCoordinates,
//         color: Color.fromARGB(255, 164, 58, 1),
//         width: 6,
//       ));
//     });

//     // Zoom to fit the entire route on the map
//     _fitToPolyline(polylineCoordinates);
//   }

//   void _fitToPolyline(List<LatLng> polylineCoordinates) {
//     LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
//     googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//   }

//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double? south, west, north, east;
//     for (LatLng latLng in list) {
//       if (south == null || latLng.latitude < south) {
//         south = latLng.latitude;
//       }
//       if (west == null || latLng.longitude < west) {
//         west = latLng.longitude;
//       }
//       if (north == null || latLng.latitude > north) {
//         north = latLng.latitude;
//       }
//       if (east == null || latLng.longitude > east) {
//         east = latLng.longitude;
//       }
//     }
//     return LatLngBounds(
//       southwest: LatLng(south!, west!),
//       northeast: LatLng(north!, east!),
//     );
//   }
// }
