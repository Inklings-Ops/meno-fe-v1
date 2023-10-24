// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$broadcastStatusHash() => r'd64b7aad2ba8233677741a561c9145ccf6471165';

/// See also [broadcastStatus].
@ProviderFor(broadcastStatus)
final broadcastStatusProvider = AutoDisposeProvider<Status>.internal(
  broadcastStatus,
  name: r'broadcastStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$broadcastStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BroadcastStatusRef = AutoDisposeProviderRef<Status>;
String _$broadcastNotifierHash() => r'9f2f54eae4fcb983e51d83b7e1791573f341a790';

/// See also [BroadcastNotifier].
@ProviderFor(BroadcastNotifier)
final broadcastNotifierProvider =
    AutoDisposeNotifierProvider<BroadcastNotifier, BroadcastState>.internal(
  BroadcastNotifier.new,
  name: r'broadcastNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$broadcastNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BroadcastNotifier = AutoDisposeNotifier<BroadcastState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
