// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_kit_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveKitEventHash() => r'7650086143d3e2d859881f0f1700191dcfc07816';

/// See also [liveKitEvent].
@ProviderFor(liveKitEvent)
final liveKitEventProvider =
    AutoDisposeProvider<EventsListener<RoomEvent>>.internal(
  liveKitEvent,
  name: r'liveKitEventProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$liveKitEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LiveKitEventRef = AutoDisposeProviderRef<EventsListener<RoomEvent>>;
String _$liveKitNotifierHash() => r'5ee4e5babd6de4279f12195f505e6dc8c6265f1a';

/// See also [LiveKitNotifier].
@ProviderFor(LiveKitNotifier)
final liveKitNotifierProvider =
    AutoDisposeNotifierProvider<LiveKitNotifier, AsyncValue<Room>>.internal(
  LiveKitNotifier.new,
  name: r'liveKitNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveKitNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveKitNotifier = AutoDisposeNotifier<AsyncValue<Room>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
