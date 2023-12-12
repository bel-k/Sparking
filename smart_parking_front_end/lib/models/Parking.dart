class Parking {
  final int id;
  final String name;
  final String description;
  final bool availabilityStatus;

  Parking({
    required this.id,
    required this.name,
    required this.description,
    required this.availabilityStatus,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      availabilityStatus: json['availabilityStatus'],
    );
  }
}
