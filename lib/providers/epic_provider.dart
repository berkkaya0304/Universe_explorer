// lib/providers/epic_provider.dart - EPIC state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/nasa_api_service.dart';
import '../models/epic_model.dart';

part 'epic_provider.g.dart';

// EPIC verileri provider'ı
@riverpod
Future<List<EpicModel>> epicData(
  EpicDataRef ref, {
  required String date,
}) async {
  final apiService = ref.watch(nasaApiServiceProvider);
  
  // Enhanced retry mechanism for build environments
  int retryCount = 0;
  const maxRetries = 5;
  const baseDelay = 1; // seconds
  
  while (retryCount < maxRetries) {
    try {
      print('EPIC Data attempt ${retryCount + 1}/$maxRetries for date: $date');
      return await apiService.getEpicData(date: date);
    } catch (e) {
      retryCount++;
      print('EPIC Data retry $retryCount/$maxRetries: $e');
      
      if (retryCount >= maxRetries) {
        print('EPIC Data failed after $maxRetries attempts');
        rethrow;
      }
      
      // Exponential backoff with jitter
      final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
      print('EPIC Data waiting ${delay.toStringAsFixed(1)} seconds before retry');
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
    }
  }
  
  throw Exception('Failed to load EPIC data after $maxRetries attempts');
}

// EPIC favorites provider
@riverpod
class EpicFavorites extends _$EpicFavorites {
  @override
  List<EpicModel> build() {
    return [];
  }

  void addToFavorites(EpicModel epic) {
    if (!state.any((element) => element.identifier == epic.identifier)) {
      state = [...state, epic.copyWith(isFavorite: true)];
    }
  }

  void removeFromFavorites(String identifier) {
    state = state.where((element) => element.identifier != identifier).toList();
  }

  bool isFavorite(String identifier) {
    return state.any((element) => element.identifier == identifier);
  }
} 