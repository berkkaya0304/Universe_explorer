// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$epicDataHash() => r'2446a7fbf91405c3424c6ebbb682b4b9d876185d';

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

/// See also [epicData].
@ProviderFor(epicData)
const epicDataProvider = EpicDataFamily();

/// See also [epicData].
class EpicDataFamily extends Family<AsyncValue<List<EpicModel>>> {
  /// See also [epicData].
  const EpicDataFamily();

  /// See also [epicData].
  EpicDataProvider call({
    required String date,
  }) {
    return EpicDataProvider(
      date: date,
    );
  }

  @override
  EpicDataProvider getProviderOverride(
    covariant EpicDataProvider provider,
  ) {
    return call(
      date: provider.date,
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
  String? get name => r'epicDataProvider';
}

/// See also [epicData].
class EpicDataProvider extends AutoDisposeFutureProvider<List<EpicModel>> {
  /// See also [epicData].
  EpicDataProvider({
    required String date,
  }) : this._internal(
          (ref) => epicData(
            ref as EpicDataRef,
            date: date,
          ),
          from: epicDataProvider,
          name: r'epicDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$epicDataHash,
          dependencies: EpicDataFamily._dependencies,
          allTransitiveDependencies: EpicDataFamily._allTransitiveDependencies,
          date: date,
        );

  EpicDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String date;

  @override
  Override overrideWith(
    FutureOr<List<EpicModel>> Function(EpicDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EpicDataProvider._internal(
        (ref) => create(ref as EpicDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<EpicModel>> createElement() {
    return _EpicDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EpicDataProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EpicDataRef on AutoDisposeFutureProviderRef<List<EpicModel>> {
  /// The parameter `date` of this provider.
  String get date;
}

class _EpicDataProviderElement
    extends AutoDisposeFutureProviderElement<List<EpicModel>> with EpicDataRef {
  _EpicDataProviderElement(super.provider);

  @override
  String get date => (origin as EpicDataProvider).date;
}

String _$epicFavoritesHash() => r'95649907d89cac95750bd4c329c6fbd4eff5c265';

/// See also [EpicFavorites].
@ProviderFor(EpicFavorites)
final epicFavoritesProvider =
    AutoDisposeNotifierProvider<EpicFavorites, List<EpicModel>>.internal(
  EpicFavorites.new,
  name: r'epicFavoritesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$epicFavoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EpicFavorites = AutoDisposeNotifier<List<EpicModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
