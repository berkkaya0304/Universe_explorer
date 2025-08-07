// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iss_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$issApiServiceHash() => r'9ebce4853cf7ebf05361b10c72f0c980de88a6c4';

/// See also [issApiService].
@ProviderFor(issApiService)
final issApiServiceProvider = AutoDisposeProvider<IssApiService>.internal(
  issApiService,
  name: r'issApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$issApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IssApiServiceRef = AutoDisposeProviderRef<IssApiService>;
String _$issLocationHash() => r'b4b52fc1bb9a2789c714617f0b0f93e225a35ae4';

/// See also [issLocation].
@ProviderFor(issLocation)
final issLocationProvider = AutoDisposeFutureProvider<IssModel>.internal(
  issLocation,
  name: r'issLocationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$issLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IssLocationRef = AutoDisposeFutureProviderRef<IssModel>;
String _$issLocationNotifierHash() =>
    r'1a234fb90c3d309562f2b3060a362c70397c03a2';

/// See also [IssLocationNotifier].
@ProviderFor(IssLocationNotifier)
final issLocationNotifierProvider =
    AutoDisposeNotifierProvider<IssLocationNotifier, IssModel?>.internal(
  IssLocationNotifier.new,
  name: r'issLocationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$issLocationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IssLocationNotifier = AutoDisposeNotifier<IssModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
