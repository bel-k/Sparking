import 'Parking.dart';

class Spot {
  final int spotId;
  final int number;
  final double price;
  final bool availabilityStatus;
  final String vehicleType;
  final bool disabled;
  final Parking parking; // Add this field

  Spot({
    required this.spotId,
    required this.number,
    required this.price,
    required this.availabilityStatus,
    required this.vehicleType,
    required this.disabled,
    required this.parking, // Add this required parameter
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      spotId: json['spotId'],
      number: json['number'],
      price: json['price'],
      availabilityStatus: json['availabilityStatus'],
      disabled: json['disabled'],
      vehicleType: json['vehicleType'],
      parking:
          Parking.fromJson(json['parking']), // Create Parking object from JSON
    );
  }
}
