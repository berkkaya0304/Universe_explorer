// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spaceWeatherDataHash() => r'c7808e10ee5cb777d363a28157e2e6cf6e4a0be4';

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

/// See also [spaceWeatherData].
@ProviderFor(spaceWeatherData)
const spaceWeatherDataProvider = SpaceWeatherDataFamily();

/// See also [spaceWeatherData].
class SpaceWeatherDataFamily
    extends Family<AsyncValue<List<SpaceWeatherModel>>> {
  /// See also [spaceWeatherData].
  const SpaceWeatherDataFamily();

  /// See also [spaceWeatherData].
  SpaceWeatherDataProvider call({
    required String startDate,
    required String endDate,
  }) {
    return SpaceWeatherDataProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  SpaceWeatherDataProvider getProviderOverride(
    covariant SpaceWeatherDataProvider provider,
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
  String? get name => r'spaceWeatherDataProvider';
}

/// See also [spaceWeatherData].
class SpaceWeatherDataProvider
    extends AutoDisposeFutureProvider<List<SpaceWeatherModel>> {
  /// See also [spaceWeatherData].
  SpaceWeatherDataProvider({
    required String startDate,
    required String endDate,
  }) : this._internal(
          (ref) => spaceWeatherData(
            ref as SpaceWeatherDataRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: spaceWeatherDataProvider,
          name: r'spaceWeatherDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spaceWeatherDataHash,
          dependencies: SpaceWeatherDataFamily._dependencies,
          allTransitiveDependencies:
              SpaceWeatherDataFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  SpaceWeatherDataProvider._internal(
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
    FutureOr<List<SpaceWeatherModel>> Function(SpaceWeatherDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SpaceWeatherDataProvider._internal(
        (ref) => create(ref as SpaceWeatherDataRef),
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
  AutoDisposeFutureProviderElement<List<SpaceWeatherModel>> createElement() {
    return _SpaceWeatherDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceWeatherDataProvider &&
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
mixin SpaceWeatherDataRef
    on AutoDisposeFutureProviderRef<List<SpaceWeatherModel>> {
  /// The parameter `startDate` of this provider.
  String get startDate;

  /// The parameter `endDate` of this provider.
  String get endDate;
}

class _SpaceWeatherDataProviderElement
    extends AutoDisposeFutureProviderElement<List<SpaceWeatherModel>>
    with SpaceWeatherDataRef {
  _SpaceWeatherDataProviderElement(super.provider);

  @override
  String get startDate => (origin as SpaceWeatherDataProvider).startDate;
  @override
  String get endDate => (origin as SpaceWeatherDataProvider).endDate;
}

String _$spaceWeatherFavoritesHash() =>
    r'8817114440ef1be984db1fef4e72cc1411356675';

/// See also [SpaceWeatherFavorites].
@ProviderFor(SpaceWeatherFavorites)
final spaceWeatherFavoritesProvider = AutoDisposeNotifierProvider<
    SpaceWeatherFavorites, List<SpaceWeatherModel>>.internal(
  SpaceWeatherFavorites.new,
  name: r'spaceWeatherFavoritesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$spaceWeatherFavoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SpaceWeatherFavorites = AutoDisposeNotifier<List<SpaceWeatherModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
