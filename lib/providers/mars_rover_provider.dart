// lib/providers/mars_rover_provider.dart - Mars Rover state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/nasa_api_service.dart';
import '../models/mars_rover_model.dart';

part 'mars_rover_provider.g.dart';

// Mars Rover fotoğrafları provider'ı
@riverpod
Future<List<MarsRoverModel>> marsRoverPhotos(
  MarsRoverPhotosRef ref, {
  required String rover,
  required String earthDate,
  String? camera,
}) async {
  final apiService = ref.watch(nasaApiServiceProvider);
  
  // Enhanced retry mechanism for build environments
  int retryCount = 0;
  const maxRetries = 5;
  const baseDelay = 1; // seconds
  
  while (retryCount < maxRetries) {
    try {
      print('Mars Rover Photos attempt ${retryCount + 1}/$maxRetries for rover: $rover, date: $earthDate');
      return await apiService.getMarsRoverPhotos(
        rover: rover,
        earthDate: earthDate,
        camera: camera,
      );
    } catch (e) {
      retryCount++;
      print('Mars Rover Photos retry $retryCount/$maxRetries: $e');
      
      if (retryCount >= maxRetries) {
        print('Mars Rover Photos failed after $maxRetries attempts');
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      print('Mars Rover Photos waiting ${delay.toStringAsFixed(1)} seconds before retry');
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load Mars Rover photos after $maxRetries attempts');
}

// Seçili rover provider'ı
@riverpod
class SelectedRover extends _$SelectedRover {
  @override
  String build() {
    return 'curiosity'; // Default rover
  }

  void setRover(String rover) {
    state = rover;
  }
}

// Selected date provider
@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  String build() {
    // Use a date when Mars Rovers were active
    // Curiosity: Active since 2012
    // Perseverance: Active since 2021
    // Opportunity: Active 2004-2019
    // Spirit: Active 2004-2010
    return '2024-01-15'; // More reliable date
  }

  void setDate(String date) {
    state = date;
  }
}

// Mars Rover favorites provider
@riverpod
class MarsRoverFavorites extends _$MarsRoverFavorites {
  @override
  List<MarsRoverModel> build() {
    return [];
  }

  void addToFavorites(MarsRoverModel photo) {
    if (!state.any((element) => element.id == photo.id)) {
      state = [...state, photo.copyWith(isFavorite: true)];
    }
  }

  void removeFromFavorites(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  bool isFavorite(int id) {
    return state.any((element) => element.id == id);
  }
} 