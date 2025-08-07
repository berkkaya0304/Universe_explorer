// lib/providers/apod_provider.dart - APOD state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/nasa_api_service.dart';
import '../models/apod_model.dart';

part 'apod_provider.g.dart';

// API servis provider'ı
@riverpod
NasaApiService nasaApiService(NasaApiServiceRef ref) {
  return NasaApiService();
}

// Günün APOD'u provider'ı
@riverpod
Future<ApodModel> todayApod(TodayApodRef ref) async {
  final apiService = ref.watch(nasaApiServiceProvider);
  
  try {
    print('Loading today\'s APOD...');
    final apod = await apiService.getApod();
    print('Today\'s APOD loaded successfully: ${apod.title}');
    return apod;
  } catch (e) {
    print('Error loading today\'s APOD: $e');
    rethrow;
  }
}

// APOD geçmişi provider'ı
@riverpod
Future<List<ApodModel>> apodHistory(
  ApodHistoryRef ref, {
  required String startDate,
  required String endDate,
}) async {
  final apiService = ref.watch(nasaApiServiceProvider);
  
  // Enhanced retry mechanism for build environments
  int retryCount = 0;
  const maxRetries = 5;
  const baseDelay = 1; // seconds
  
  while (retryCount < maxRetries) {
    try {
      print('APOD History attempt ${retryCount + 1}/$maxRetries');
      return await apiService.getApodHistory(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      retryCount++;
      print('APOD History retry $retryCount/$maxRetries: $e');
      
      if (retryCount >= maxRetries) {
        print('APOD History failed after $maxRetries attempts');
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      print('APOD History waiting ${delay.toStringAsFixed(1)} seconds before retry');
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load APOD history data after $maxRetries attempts');
}

// APOD favorites provider
@riverpod
class ApodFavorites extends _$ApodFavorites {
  @override
  List<ApodModel> build() {
    return [];
  }

  void addToFavorites(ApodModel apod) {
    if (!state.any((element) => element.date == apod.date)) {
      state = [...state, apod.copyWith(isFavorite: true)];
    }
  }

  void removeFromFavorites(String date) {
    state = state.where((element) => element.date != date).toList();
  }

  bool isFavorite(String date) {
    return state.any((element) => element.date == date);
  }
} 