// lib/api/iss_api_service.dart - ISS konum servisi
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../models/iss_model.dart';

class IssApiService {
  late final Dio _dio;
  
  IssApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://api.open-notify.org',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

      // Get current ISS location
  Future<IssModel> getIssLocation() async {
    try {
      final response = await _dio.get('/iss-now.json');
      
      if (response.statusCode == 200) {
        return IssModel.fromJson(response.data);
      } else {
        throw Exception('Could not get ISS location');
      }
    } catch (e) {
              throw Exception('ISS service error: $e');
    }
  }

  // ISS'in geçmiş konumlarını getir (opsiyonel)
  Future<List<IssModel>> getIssLocationHistory() async {
    try {
      // Bu endpoint gerçek API'de mevcut olmayabilir, örnek amaçlı
      final response = await _dio.get('/iss-pass.json');
      
      if (response.statusCode == 200) {
        // Bu kısım gerçek API yapısına göre değiştirilmeli
        return [];
      } else {
        throw Exception('Could not get ISS historical location');
      }
    } catch (e) {
              throw Exception('ISS historical service error: $e');
    }
  }
} 

// ISS API Service Provider
final issApiServiceProvider = Provider<IssApiService>((ref) {
  return IssApiService();
}); 