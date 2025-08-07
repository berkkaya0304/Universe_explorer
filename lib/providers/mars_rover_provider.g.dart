// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mars_rover_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marsRoverPhotosHash() => r'65072b250f55e70460e209b0e5fba8c6a7fdb5af';

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

/// See also [marsRoverPhotos].
@ProviderFor(marsRoverPhotos)
const marsRoverPhotosProvider = MarsRoverPhotosFamily();

/// See also [marsRoverPhotos].
class MarsRoverPhotosFamily extends Family<AsyncValue<List<MarsRoverModel>>> {
  /// See also [marsRoverPhotos].
  const MarsRoverPhotosFamily();

  /// See also [marsRoverPhotos].
  MarsRoverPhotosProvider call({
    required String rover,
    required String earthDate,
    String? camera,
  }) {
    return MarsRoverPhotosProvider(
      rover: rover,
      earthDate: earthDate,
      camera: camera,
    );
  }

  @override
  MarsRoverPhotosProvider getProviderOverride(
    covariant MarsRoverPhotosProvider provider,
  ) {
    return call(
      rover: provider.rover,
      earthDate: provider.earthDate,
      camera: provider.camera,
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
  String? get name => r'marsRoverPhotosProvider';
}

/// See also [marsRoverPhotos].
class MarsRoverPhotosProvider
    extends AutoDisposeFutureProvider<List<MarsRoverModel>> {
  /// See also [marsRoverPhotos].
  MarsRoverPhotosProvider({
    required String rover,
    required String earthDate,
    String? camera,
  }) : this._internal(
          (ref) => marsRoverPhotos(
            ref as MarsRoverPhotosRef,
            rover: rover,
            earthDate: earthDate,
            camera: camera,
          ),
          from: marsRoverPhotosProvider,
          name: r'marsRoverPhotosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marsRoverPhotosHash,
          dependencies: MarsRoverPhotosFamily._dependencies,
          allTransitiveDependencies:
              MarsRoverPhotosFamily._allTransitiveDependencies,
          rover: rover,
          earthDate: earthDate,
          camera: camera,
        );

  MarsRoverPhotosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rover,
    required this.earthDate,
    required this.camera,
  }) : super.internal();

  final String rover;
  final String earthDate;
  final String? camera;

  @override
  Override overrideWith(
    FutureOr<List<MarsRoverModel>> Function(MarsRoverPhotosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarsRoverPhotosProvider._internal(
        (ref) => create(ref as MarsRoverPhotosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rover: rover,
        earthDate: earthDate,
        camera: camera,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MarsRoverModel>> createElement() {
    return _MarsRoverPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarsRoverPhotosProvider &&
        other.rover == rover &&
        other.earthDate == earthDate &&
        other.camera == camera;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rover.hashCode);
    hash = _SystemHash.combine(hash, earthDate.hashCode);
    hash = _SystemHash.combine(hash, camera.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarsRoverPhotosRef on AutoDisposeFutureProviderRef<List<MarsRoverModel>> {
  /// The parameter `rover` of this provider.
  String get rover;

  /// The parameter `earthDate` of this provider.
  String get earthDate;

  /// The parameter `camera` of this provider.
  String? get camera;
}

class _MarsRoverPhotosProviderElement
    extends AutoDisposeFutureProviderElement<List<MarsRoverModel>>
    with MarsRoverPhotosRef {
  _MarsRoverPhotosProviderElement(super.provider);

  @override
  String get rover => (origin as MarsRoverPhotosProvider).rover;
  @override
  String get earthDate => (origin as MarsRoverPhotosProvider).earthDate;
  @override
  String? get camera => (origin as MarsRoverPhotosProvider).camera;
}

String _$selectedRoverHash() => r'7cfe9f50b13966941aa58b03624cfbcdeb4b76d0';

/// See also [SelectedRover].
@ProviderFor(SelectedRover)
final selectedRoverProvider =
    AutoDisposeNotifierProvider<SelectedRover, String>.internal(
  SelectedRover.new,
  name: r'selectedRoverProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRoverHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRover = AutoDisposeNotifier<String>;
String _$selectedDateHash() => r'a5be30ee922128efbccb0b3fe394b469a4e3bc6e';

/// See also [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider =
    AutoDisposeNotifierProvider<SelectedDate, String>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = AutoDisposeNotifier<String>;
String _$marsRoverFavoritesHash() =>
    r'8149f42a2693b3656653ff39bdf0691c549f6d1e';

/// See also [MarsRoverFavorites].
@ProviderFor(MarsRoverFavorites)
final marsRoverFavoritesProvider = AutoDisposeNotifierProvider<
    MarsRoverFavorites, List<MarsRoverModel>>.internal(
  MarsRoverFavorites.new,
  name: r'marsRoverFavoritesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marsRoverFavoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarsRoverFavorites = AutoDisposeNotifier<List<MarsRoverModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
