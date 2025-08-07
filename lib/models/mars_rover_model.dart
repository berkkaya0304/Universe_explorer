// lib/models/mars_rover_model.dart - Mars Rover fotoğraf modeli
class MarsRoverModel {
  final int id;
  final String imgSrc;
  final String earthDate;
  final String roverName;
  final String cameraName;
  final String cameraFullName;
  final bool isFavorite;

  MarsRoverModel({
    required this.id,
    required this.imgSrc,
    required this.earthDate,
    required this.roverName,
    required this.cameraName,
    required this.cameraFullName,
    this.isFavorite = false,
  });

  factory MarsRoverModel.fromJson(Map<String, dynamic> json) {
    return MarsRoverModel(
      id: json['id'] ?? 0,
      imgSrc: json['img_src'] ?? '',
      earthDate: json['earth_date'] ?? '',
      roverName: json['rover']?['name'] ?? '',
      cameraName: json['camera']?['name'] ?? '',
      cameraFullName: json['camera']?['full_name'] ?? '',
    );
  }

  // Getter for rover object to maintain compatibility
  Map<String, dynamic> get rover => {
    'name': roverName,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_src': imgSrc,
      'earth_date': earthDate,
      'rover': {
        'name': roverName,
      },
      'camera': {
        'name': cameraName,
        'full_name': cameraFullName,
      },
    };
  }

  MarsRoverModel copyWith({
    int? id,
    String? imgSrc,
    String? earthDate,
    String? roverName,
    String? cameraName,
    String? cameraFullName,
    bool? isFavorite,
  }) {
    return MarsRoverModel(
      id: id ?? this.id,
      imgSrc: imgSrc ?? this.imgSrc,
      earthDate: earthDate ?? this.earthDate,
      roverName: roverName ?? this.roverName,
      cameraName: cameraName ?? this.cameraName,
      cameraFullName: cameraFullName ?? this.cameraFullName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 