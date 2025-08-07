// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apod_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nasaApiServiceHash() => r'db2d2e0362d891fd40e51430bb39ea586bb1e2b9';

/// See also [nasaApiService].
@ProviderFor(nasaApiService)
final nasaApiServiceProvider = AutoDisposeProvider<NasaApiService>.internal(
  nasaApiService,
  name: r'nasaApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nasaApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NasaApiServiceRef = AutoDisposeProviderRef<NasaApiService>;
String _$todayApodHash() => r'830b96c698565010689bad157b1d176099e312e8';

/// See also [todayApod].
@ProviderFor(todayApod)
final todayApodProvider = AutoDisposeFutureProvider<ApodModel>.internal(
  todayApod,
  name: r'todayApodProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayApodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayApodRef = AutoDisposeFutureProviderRef<ApodModel>;
String _$apodHistoryHash() => r'9381b6ef5ce7cdefb8fc62b2de537f013c55ade2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [apodHistory].
@ProviderFor(apodHistory)
const apodHistoryProvider = ApodHistoryFamily();

/// See also [apodHistory].
class ApodHistoryFamily extends Family<AsyncValue<List<ApodModel>>> {
  /// See also [apodHistory].
  const ApodHistoryFamily();

  /// See also [apodHistory].
  ApodHistoryProvider call({
    required String startDate,
    required String endDate,
  }) {
    return ApodHistoryProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  ApodHistoryProvider getProviderOverride(
    covariant ApodHistoryProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'apodHistoryProvider';
}

/// See also [apodHistory].
class ApodHistoryProvider extends AutoDisposeFutureProvider<List<ApodModel>> {
  /// See also [apodHistory].
  ApodHistoryProvider({
    required String startDate,
    required String endDate,
  }) : this._internal(
          (ref) => apodHistory(
            ref as ApodHistoryRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: apodHistoryProvider,
          name: r'apodHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apodHistoryHash,
          dependencies: ApodHistoryFamily._dependencies,
          allTransitiveDependencies:
              ApodHistoryFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  ApodHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String startDate;
  final String endDate;

  @override
  Override overrideWith(
    FutureOr<List<ApodModel>> Function(ApodHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApodHistoryProvider._internal(
        (ref) => create(ref as ApodHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ApodModel>> createElement() {
    return _ApodHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApodHistoryProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApodHistoryRef on AutoDisposeFutureProviderRef<List<ApodModel>> {
  /// The parameter `startDate` of this provider.
  String get startDate;

  /// The parameter `endDate` of this provider.
  String get endDate;
}

class _ApodHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<ApodModel>>
    with ApodHistoryRef {
  _ApodHistoryProviderElement(super.provider);

  @override
  String get startDate => (origin as ApodHistoryProvider).startDate;
  @override
  String get endDate => (origin as ApodHistoryProvider).endDate;
}

String _$apodFavoritesHash() => r'a359f8ba9c5b5c12eab49fac8e34b05a90315237';

/// See also [ApodFavorites].
@ProviderFor(ApodFavorites)
final apodFavoritesProvider =
    AutoDisposeNotifierProvider<ApodFavorites, List<ApodModel>>.internal(
  ApodFavorites.new,
  name: r'apodFavoritesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apodFavoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApodFavorites = AutoDisposeNotifier<List<ApodModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
