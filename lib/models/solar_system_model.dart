// lib/models/solar_system_model.dart - Solar System Bodies model sınıfı
class SolarSystemModel {
  final String id;
  final String name;
  final String englishName;
  final bool isPlanet;
  final List<Moon> moons;
  final double mass;
  final double volume;
  final double density;
  final double gravity;
  final double meanRadius;
  final double sideralOrbit;
  final double sideralRotation;

  SolarSystemModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.isPlanet,
    required this.moons,
    required this.mass,
    required this.volume,
    required this.density,
    required this.gravity,
    required this.meanRadius,
    required this.sideralOrbit,
    required this.sideralRotation,
  });

  factory SolarSystemModel.fromJson(Map<String, dynamic> json) {
    return SolarSystemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      isPlanet: json['isPlanet'] ?? false,
      moons: (json['moons'] as List<dynamic>?)
          ?.map((moon) => Moon.fromJson(moon))
          .toList() ?? [],
      mass: (json['mass'] ?? 0.0).toDouble(),
      volume: (json['volume'] ?? 0.0).toDouble(),
      density: (json['density'] ?? 0.0).toDouble(),
      gravity: (json['gravity'] ?? 0.0).toDouble(),
      meanRadius: (json['meanRadius'] ?? 0.0).toDouble(),
      sideralOrbit: (json['sideralOrbit'] ?? 0.0).toDouble(),
      sideralRotation: (json['sideralRotation'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'englishName': englishName,
      'isPlanet': isPlanet,
      'moons': moons.map((moon) => moon.toJson()).toList(),
      'mass': mass,
      'volume': volume,
      'density': density,
      'gravity': gravity,
      'meanRadius': meanRadius,
      'sideralOrbit': sideralOrbit,
      'sideralRotation': sideralRotation,
    };
  }
}

class Moon {
  final String moon;
  final String rel;

  Moon({
    required this.moon,
    required this.rel,
  });

  factory Moon.fromJson(Map<String, dynamic> json) {
    return Moon(
      moon: json['moon'] ?? '',
      rel: json['rel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moon': moon,
      'rel': rel,
    };
  }
} 