import 'package:dartz/dartz.dart';

import 'entities/entities.dart';
import 'exceptions/broadcast_exception.dart';
import 'inputs/inputs.dart';

abstract class IBroadcastFacade {
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    String? timeZone,
    List<String>? cohosts,
  });

  Future<Either<BroadcastException, Unit>> deleteBroadcast({
    required BroadcastId broadcastId,
  });

  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required BroadcastId broadcastId,
    IBroadcastTitle? title,
    IBroadcastDescription? description,
    IBroadcastArtwork? image,
    String? timeZone,
    DateTime? startTime,
  });

  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast({
    required BroadcastId broadcastId,
  });

  Future<Either<BroadcastException, Broadcast>> startBroadcast({
    required BroadcastId broadcastId,
  });
}
