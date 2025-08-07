// lib/providers/iss_provider.dart - ISS state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/iss_api_service.dart';
import '../models/iss_model.dart';

part 'iss_provider.g.dart';

// ISS API servis provider'ı
@riverpod
IssApiService issApiService(IssApiServiceRef ref) {
  return IssApiService();
}

// ISS mevcut konum provider'ı
@riverpod
Future<IssModel> issLocation(IssLocationRef ref) async {
  final apiService = ref.watch(issApiServiceProvider);
  return await apiService.getIssLocation();
}

// ISS konum güncelleme provider'ı (gerçek zamanlı)
@riverpod
class IssLocationNotifier extends _$IssLocationNotifier {
  @override
  IssModel? build() {
    return null;
  }

  Future<void> updateLocation() async {
    final apiService = ref.read(issApiServiceProvider);
    try {
      final location = await apiService.getIssLocation();
      state = location;
    } catch (e) {
      // Don't change state on error
    }
  }
} 