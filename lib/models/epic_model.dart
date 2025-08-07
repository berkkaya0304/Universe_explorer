// lib/models/epic_model.dart - EPIC model sınıfı
class EpicModel {
  final String identifier;
  final String caption;
  final String image;
  final String version;
  final String date;
  final double latitude;
  final double longitude;
  final String centroidCoordinates;
  final String dscovrJ2000Position;
  final String lunarJ2000Position;
  final String sunJ2000Position;
  final String attitudeQuaternions;
  final bool isFavorite;

  EpicModel({
    required this.identifier,
    required this.caption,
    required this.image,
    required this.version,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.centroidCoordinates,
    required this.dscovrJ2000Position,
    required this.lunarJ2000Position,
    required this.sunJ2000Position,
    required this.attitudeQuaternions,
    this.isFavorite = false,
  });

  factory EpicModel.fromJson(Map<String, dynamic> json) {
    return EpicModel(
      identifier: json['identifier'] ?? '',
      caption: json['caption'] ?? '',
      image: json['image'] ?? '',
      version: json['version'] ?? '',
      date: json['date'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      centroidCoordinates: json['centroid_coordinates']?.toString() ?? '',
      dscovrJ2000Position: json['dscovr_j2000_position']?.toString() ?? '',
      lunarJ2000Position: json['lunar_j2000_position']?.toString() ?? '',
      sunJ2000Position: json['sun_j2000_position']?.toString() ?? '',
      attitudeQuaternions: json['attitude_quaternions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'caption': caption,
      'image': image,
      'version': version,
      'date': date,
      'latitude': latitude,
      'longitude': longitude,
      'centroid_coordinates': centroidCoordinates,
      'dscovr_j2000_position': dscovrJ2000Position,
      'lunar_j2000_position': lunarJ2000Position,
      'sun_j2000_position': sunJ2000Position,
      'attitude_quaternions': attitudeQuaternions,
    };
  }

  String get imageUrl {
    final dateParts = date.split(' ')[0].split('-');
    return 'https://epic.gsfc.nasa.gov/archive/natural/${dateParts[0]}/${dateParts[1]}/${dateParts[2]}/png/$image.png';
  }

  EpicModel copyWith({
    String? identifier,
    String? caption,
    String? image,
    String? version,
    String? date,
    double? latitude,
    double? longitude,
    String? centroidCoordinates,
    String? dscovrJ2000Position,
    String? lunarJ2000Position,
    String? sunJ2000Position,
    String? attitudeQuaternions,
    bool? isFavorite,
  }) {
    return EpicModel(
      identifier: identifier ?? this.identifier,
      caption: caption ?? this.caption,
      image: image ?? this.image,
      version: version ?? this.version,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      centroidCoordinates: centroidCoordinates ?? this.centroidCoordinates,
      dscovrJ2000Position: dscovrJ2000Position ?? this.dscovrJ2000Position,
      lunarJ2000Position: lunarJ2000Position ?? this.lunarJ2000Position,
      sunJ2000Position: sunJ2000Position ?? this.sunJ2000Position,
      attitudeQuaternions: attitudeQuaternions ?? this.attitudeQuaternions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 