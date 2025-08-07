// lib/providers/space_weather_provider.dart - Space Weather state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/nasa_api_service.dart';
import '../models/space_weather_model.dart';

part 'space_weather_provider.g.dart';

// Space Weather verileri provider'ı
@riverpod
Future<List<SpaceWeatherModel>> spaceWeatherData(
  SpaceWeatherDataRef ref, {
  required String startDate,
  required String endDate,
}) async {
  final apiService = ref.watch(nasaApiServiceProvider);
  
  // Enhanced retry mechanism for build environments
  int retryCount = 0;
  const maxRetries = 3;
  const baseDelay = 1; // seconds
  
  while (retryCount < maxRetries) {
    try {
      return await apiService.getSpaceWeatherData(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      retryCount++;
      
      if (retryCount >= maxRetries) {
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load Space Weather data after $maxRetries attempts');
}

// Space Weather favorites provider
@riverpod
class SpaceWeatherFavorites extends _$SpaceWeatherFavorites {
  @override
  List<SpaceWeatherModel> build() {
    return [];
  }

  void addToFavorites(SpaceWeatherModel weather) {
    if (!state.any((element) => element.activityID == weather.activityID)) {
      state = [...state, weather.copyWith(isFavorite: true)];
    }
  }

  void removeFromFavorites(String activityID) {
    state = state.where((element) => element.activityID != activityID).toList();
  }

  bool isFavorite(String activityID) {
    return state.any((element) => element.activityID == activityID);
  }
} 