// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asteroid_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$asteroidDataHash() => r'd72bf985e147efbe46a28e4ae5f84d2c46b84f71';

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

/// See also [asteroidData].
@ProviderFor(asteroidData)
const asteroidDataProvider = AsteroidDataFamily();

/// See also [asteroidData].
class AsteroidDataFamily extends Family<AsyncValue<List<AsteroidModel>>> {
  /// See also [asteroidData].
  const AsteroidDataFamily();

  /// See also [asteroidData].
  AsteroidDataProvider call({
    required String startDate,
    required String endDate,
  }) {
    return AsteroidDataProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  AsteroidDataProvider getProviderOverride(
    covariant AsteroidDataProvider provider,
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
  String? get name => r'asteroidDataProvider';
}

/// See also [asteroidData].
class AsteroidDataProvider
    extends AutoDisposeFutureProvider<List<AsteroidModel>> {
  /// See also [asteroidData].
  AsteroidDataProvider({
    required String startDate,
    required String endDate,
  }) : this._internal(
          (ref) => asteroidData(
            ref as AsteroidDataRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: asteroidDataProvider,
          name: r'asteroidDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$asteroidDataHash,
          dependencies: AsteroidDataFamily._dependencies,
          allTransitiveDependencies:
              AsteroidDataFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  AsteroidDataProvider._internal(
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
    FutureOr<List<AsteroidModel>> Function(AsteroidDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AsteroidDataProvider._internal(
        (ref) => create(ref as AsteroidDataRef),
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
  AutoDisposeFutureProviderElement<List<AsteroidModel>> createElement() {
    return _AsteroidDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AsteroidDataProvider &&
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
mixin AsteroidDataRef on AutoDisposeFutureProviderRef<List<AsteroidModel>> {
  /// The parameter `startDate` of this provider.
  String get startDate;

  /// The parameter `endDate` of this provider.
  String get endDate;
}

class _AsteroidDataProviderElement
    extends AutoDisposeFutureProviderElement<List<AsteroidModel>>
    with AsteroidDataRef {
  _AsteroidDataProviderElement(super.provider);

  @override
  String get startDate => (origin as AsteroidDataProvider).startDate;
  @override
  String get endDate => (origin as AsteroidDataProvider).endDate;
}

String _$nextWeekAsteroidsHash() => r'9e7f113db6ef37b5e36e07498bb6e7a34298039c';

/// See also [nextWeekAsteroids].
@ProviderFor(nextWeekAsteroids)
final nextWeekAsteroidsProvider =
    AutoDisposeFutureProvider<List<AsteroidModel>>.internal(
  nextWeekAsteroids,
  name: r'nextWeekAsteroidsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextWeekAsteroidsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NextWeekAsteroidsRef
    = AutoDisposeFutureProviderRef<List<AsteroidModel>>;
String _$asteroidFavoritesHash() => r'b2b5c6bb168f199ea6e708097807f0498c7c3d16';

/// See also [AsteroidFavorites].
@ProviderFor(AsteroidFavorites)
final asteroidFavoritesProvider = AutoDisposeNotifierProvider<AsteroidFavorites,
    List<AsteroidModel>>.internal(
  AsteroidFavorites.new,
  name: r'asteroidFavoritesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$asteroidFavoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsteroidFavorites = AutoDisposeNotifier<List<AsteroidModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
