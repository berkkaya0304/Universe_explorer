// lib/models/space_weather_model.dart - Space Weather model sınıfı
import 'package:flutter/material.dart';

class SpaceWeatherModel {
  final String activityID;
  final String eventTime;
  final String instrument;
  final String satellite;
  final String detectionDate;
  final String initialTime;
  final String finalTime;
  final String type;
  final String sourceLocation;
  final String activeRegionNum;
  final String linkedEvents;
  final String link;
  final bool isFavorite;

  SpaceWeatherModel({
    required this.activityID,
    required this.eventTime,
    required this.instrument,
    required this.satellite,
    required this.detectionDate,
    required this.initialTime,
    required this.finalTime,
    required this.type,
    required this.sourceLocation,
    required this.activeRegionNum,
    required this.linkedEvents,
    required this.link,
    this.isFavorite = false,
  });

  factory SpaceWeatherModel.fromJson(Map<String, dynamic> json) {
    return SpaceWeatherModel(
      activityID: json['activityID'] ?? '',
      eventTime: json['eventTime'] ?? '',
      instrument: json['instrument'] ?? '',
      satellite: json['satellite'] ?? '',
      detectionDate: json['detectionDate'] ?? '',
      initialTime: json['initialTime'] ?? '',
      finalTime: json['finalTime'] ?? '',
      type: json['type'] ?? '',
      sourceLocation: json['sourceLocation'] ?? '',
      activeRegionNum: json['activeRegionNum'] ?? '',
      linkedEvents: json['linkedEvents'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityID': activityID,
      'eventTime': eventTime,
      'instrument': instrument,
      'satellite': satellite,
      'detectionDate': detectionDate,
      'initialTime': initialTime,
      'finalTime': finalTime,
      'type': type,
      'sourceLocation': sourceLocation,
      'activeRegionNum': activeRegionNum,
      'linkedEvents': linkedEvents,
      'link': link,
    };
  }

  String get formattedEventTime {
    if (eventTime.isEmpty) return 'Bilinmiyor';
    try {
      final date = DateTime.parse(eventTime);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return eventTime;
    }
  }

  String get severity {
    switch (type.toLowerCase()) {
      case 'cme':
        return 'Orta';
      case 'flare':
        return 'Yüksek';
      case 'storm':
        return 'Kritik';
      default:
        return 'Düşük';
    }
  }

  Color get severityColor {
    switch (severity) {
      case 'Kritik':
        return Colors.red;
      case 'Yüksek':
        return Colors.orange;
      case 'Orta':
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  SpaceWeatherModel copyWith({
    String? activityID,
    String? eventTime,
    String? instrument,
    String? satellite,
    String? detectionDate,
    String? initialTime,
    String? finalTime,
    String? type,
    String? sourceLocation,
    String? activeRegionNum,
    String? linkedEvents,
    String? link,
    bool? isFavorite,
  }) {
    return SpaceWeatherModel(
      activityID: activityID ?? this.activityID,
      eventTime: eventTime ?? this.eventTime,
      instrument: instrument ?? this.instrument,
      satellite: satellite ?? this.satellite,
      detectionDate: detectionDate ?? this.detectionDate,
      initialTime: initialTime ?? this.initialTime,
      finalTime: finalTime ?? this.finalTime,
      type: type ?? this.type,
      sourceLocation: sourceLocation ?? this.sourceLocation,
      activeRegionNum: activeRegionNum ?? this.activeRegionNum,
      linkedEvents: linkedEvents ?? this.linkedEvents,
      link: link ?? this.link,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 