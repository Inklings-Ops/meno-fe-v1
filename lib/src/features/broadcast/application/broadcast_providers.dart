import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injector/injector.dart';
import '../domain/domain.dart';

part 'broadcast_providers.g.dart';

@riverpod
IBroadcastFacade broadcastFacade(BroadcastFacadeRef ref) {
  return di<IBroadcastFacade>();
}

@riverpod
Raw<FutureOr<Either<BroadcastException, Broadcast>>> createBroadcast(
  CreateBroadcastRef ref, {
  required IBroadcastTitle title,
  IBroadcastDescription? description,
  IBroadcastArtwork? artwork,
  String? timeZone,
  List<String>? cohosts,
}) async {
  final facade = di<IBroadcastFacade>();
  return await facade.createBroadcast(
    title: title,
    description: description,
    artwork: artwork,
    cohosts: cohosts,
    timeZone: timeZone,
  );
}
