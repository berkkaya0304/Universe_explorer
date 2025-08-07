// lib/models/iss_model.dart - ISS konum modeli
class IssModel {
  final double latitude;
  final double longitude;
  final String timestamp;

  IssModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory IssModel.fromJson(Map<String, dynamic> json) {
    final position = json['iss_position'] ?? {};
    return IssModel(
      latitude: double.tryParse(position['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(position['longitude']?.toString() ?? '0') ?? 0.0,
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iss_position': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'timestamp': timestamp,
    };
  }
} 