// lib/models/asteroid_model.dart - Asteroid veri modeli
class AsteroidModel {
  final String id;
  final String name;
  final double estimatedDiameter;
  final double velocity;
  final String closeApproachDate;
  final double missDistance;
  final bool isPotentiallyHazardous;
  final bool isFavorite;

  AsteroidModel({
    required this.id,
    required this.name,
    required this.estimatedDiameter,
    required this.velocity,
    required this.closeApproachDate,
    required this.missDistance,
    required this.isPotentiallyHazardous,
    this.isFavorite = false,
  });

  factory AsteroidModel.fromJson(Map<String, dynamic> json) {
    try {
      final closeApproachData = json['close_approach_data']?[0];
      
      // API'den gelen veri yapısını kontrol et
      double estimatedDiameter = 0.0;
      if (json['estimated_diameter']?['kilometers'] != null) {
        final kmData = json['estimated_diameter']['kilometers'];
        estimatedDiameter = (kmData['estimated_diameter_min'] ?? kmData['estimated_diameter_max'] ?? 0.0).toDouble();
      }
      
      double velocity = 0.0;
      if (closeApproachData?['relative_velocity']?['kilometers_per_hour'] != null) {
        velocity = double.tryParse(closeApproachData['relative_velocity']['kilometers_per_hour'].toString()) ?? 0.0;
      }
      
      double missDistance = 0.0;
      if (closeApproachData?['miss_distance']?['kilometers'] != null) {
        missDistance = double.tryParse(closeApproachData['miss_distance']['kilometers'].toString()) ?? 0.0;
      }
      
      return AsteroidModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        estimatedDiameter: estimatedDiameter,
        velocity: velocity,
        closeApproachDate: closeApproachData?['close_approach_date']?.toString() ?? '',
        missDistance: missDistance,
        isPotentiallyHazardous: json['is_potentially_hazardous_asteroid'] == true,
      );
    } catch (e) {
              print('AsteroidModel.fromJson error: $e');
              print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'estimated_diameter': {
        'kilometers': {
          'estimated_diameter_min': estimatedDiameter,
        }
      },
      'close_approach_data': [
        {
          'close_approach_date': closeApproachDate,
          'relative_velocity': {
            'kilometers_per_hour': velocity,
          },
          'miss_distance': {
            'kilometers': missDistance,
          }
        }
      ],
      'is_potentially_hazardous_asteroid': isPotentiallyHazardous,
    };
  }

  AsteroidModel copyWith({
    String? id,
    String? name,
    double? estimatedDiameter,
    double? velocity,
    String? closeApproachDate,
    double? missDistance,
    bool? isPotentiallyHazardous,
    bool? isFavorite,
  }) {
    return AsteroidModel(
      id: id ?? this.id,
      name: name ?? this.name,
      estimatedDiameter: estimatedDiameter ?? this.estimatedDiameter,
      velocity: velocity ?? this.velocity,
      closeApproachDate: closeApproachDate ?? this.closeApproachDate,
      missDistance: missDistance ?? this.missDistance,
      isPotentiallyHazardous: isPotentiallyHazardous ?? this.isPotentiallyHazardous,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 