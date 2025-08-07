// lib/models/apod_model.dart - APOD API response modeli
class ApodModel {
  final String copyright;
  final String date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;
  final bool isFavorite;

  ApodModel({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
    this.isFavorite = false,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      copyright: json['copyright'] ?? '',
      date: json['date'] ?? '',
      explanation: json['explanation'] ?? '',
      hdurl: json['hdurl'] ?? '',
      mediaType: json['media_type'] ?? '',
      serviceVersion: json['service_version'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'copyright': copyright,
      'date': date,
      'explanation': explanation,
      'hdurl': hdurl,
      'media_type': mediaType,
      'service_version': serviceVersion,
      'title': title,
      'url': url,
    };
  }

  ApodModel copyWith({
    String? copyright,
    String? date,
    String? explanation,
    String? hdurl,
    String? mediaType,
    String? serviceVersion,
    String? title,
    String? url,
    bool? isFavorite,
  }) {
    return ApodModel(
      copyright: copyright ?? this.copyright,
      date: date ?? this.date,
      explanation: explanation ?? this.explanation,
      hdurl: hdurl ?? this.hdurl,
      mediaType: mediaType ?? this.mediaType,
      serviceVersion: serviceVersion ?? this.serviceVersion,
      title: title ?? this.title,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 