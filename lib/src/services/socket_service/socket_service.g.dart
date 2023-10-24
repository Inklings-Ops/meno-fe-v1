// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socketHash() => r'4d2436a08b4de04d42d26cc25b20f1345b1d10e4';

/// See also [socket].
@ProviderFor(socket)
final socketProvider = AutoDisposeProvider<ValueNotifier<SocketState>>.internal(
  socket,
  name: r'socketProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$socketHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SocketRef = AutoDisposeProviderRef<ValueNotifier<SocketState>>;
String _$socketStreamHash() => r'54b05f7bf8571bb8577f3f01726777cdb99a59ef';

/// See also [socketStream].
@ProviderFor(socketStream)
final socketStreamProvider = AutoDisposeStreamProvider<SocketState>.internal(
  socketStream,
  name: r'socketStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$socketStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SocketStreamRef = AutoDisposeStreamProviderRef<SocketState>;
String _$liveParticipantsHash() => r'ce9b82da77a670f30639b21fc51bf9ccd6589f0a';

/// See also [liveParticipants].
@ProviderFor(liveParticipants)
final liveParticipantsProvider =
    AutoDisposeProvider<List<Participant?>>.internal(
  liveParticipants,
  name: r'liveParticipantsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveParticipantsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LiveParticipantsRef = AutoDisposeProviderRef<List<Participant?>>;
String _$socketServiceHash() => r'd688ddea4eb2acd46bc3548cf9ef7cdf706e9981';

/// See also [SocketService].
@ProviderFor(SocketService)
final socketServiceProvider =
    AutoDisposeNotifierProvider<SocketService, SocketState>.internal(
  SocketService.new,
  name: r'socketServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socketServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SocketService = AutoDisposeNotifier<SocketState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
