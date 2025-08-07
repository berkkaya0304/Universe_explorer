// lib/providers/solar_system_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/nasa_api_service.dart';
import '../models/solar_system_model.dart';

// 1. Tüm güneş sistemi cisimlerini getiren ana provider.
final solarSystemProvider = FutureProvider<List<SolarSystemModel>>((ref) {
  final apiService = ref.watch(nasaApiServiceProvider);
  return apiService.getSolarSystemBodies();
});

// 2. Arama çubuğundaki metni tutan state provider.
final solarSystemSearchQueryProvider = StateProvider<String>((ref) => '');

// 3. Ana veriyi ve arama sorgusunu kullanarak filtrelenmiş listeyi oluşturan provider.
final filteredSolarSystemProvider = Provider<List<SolarSystemModel>>((ref) {
  final solarSystemAsyncValue = ref.watch(solarSystemProvider);
  final searchQuery = ref.watch(solarSystemSearchQueryProvider);

  return solarSystemAsyncValue.when(
    data: (bodies) {
      if (searchQuery.isEmpty) {
        return bodies;
      }
      return bodies
          .where((body) =>
              body.englishName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});