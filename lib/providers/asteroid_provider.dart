// lib/providers/asteroid_provider.dart - Asteroid state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/nasa_api_service.dart';
import '../models/asteroid_model.dart';

part 'asteroid_provider.g.dart';

// Asteroid verileri provider'ı
@riverpod
Future<List<AsteroidModel>> asteroidData(
  AsteroidDataRef ref, {
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
      print('Asteroid Data attempt ${retryCount + 1}/$maxRetries for period: $startDate to $endDate');
      return await apiService.getAsteroidData(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      retryCount++;
      print('Asteroid Data retry $retryCount/$maxRetries: $e');
      
      if (retryCount >= maxRetries) {
        print('Asteroid Data failed after $maxRetries attempts');
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      print('Asteroid Data waiting ${delay.toStringAsFixed(1)} seconds before retry');
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load asteroid data after $maxRetries attempts');
}

// Gelecek 7 gün için asteroid verileri
@riverpod
Future<List<AsteroidModel>> nextWeekAsteroids(NextWeekAsteroidsRef ref) async {
  final now = DateTime.now();
  final endDate = now.add(const Duration(days: 7));
  
  final startDateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final endDateStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
  
  final apiService = ref.watch(nasaApiServiceProvider);
  
  // Enhanced retry mechanism for build environments
  int retryCount = 0;
  const maxRetries = 5;
  const baseDelay = 1; // seconds
  
  while (retryCount < maxRetries) {
    try {
      print('Next Week Asteroids attempt ${retryCount + 1}/$maxRetries');
      return await apiService.getAsteroidData(
        startDate: startDateStr,
        endDate: endDateStr,
      );
    } catch (e) {
      retryCount++;
      print('Next Week Asteroids retry $retryCount/$maxRetries: $e');
      
      if (retryCount >= maxRetries) {
        print('Next Week Asteroids failed after $maxRetries attempts');
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      print('Next Week Asteroids waiting ${delay.toStringAsFixed(1)} seconds before retry');
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load next week asteroid data after $maxRetries attempts');
}

// Asteroid favorites provider
@riverpod
class AsteroidFavorites extends _$AsteroidFavorites {
  @override
  List<AsteroidModel> build() {
    return [];
  }

  void addToFavorites(AsteroidModel asteroid) {
    if (!state.any((element) => element.id == asteroid.id)) {
      state = [...state, asteroid.copyWith(isFavorite: true)];
    }
  }

  void removeFromFavorites(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  bool isFavorite(String id) {
    return state.any((element) => element.id == id);
  }
} 