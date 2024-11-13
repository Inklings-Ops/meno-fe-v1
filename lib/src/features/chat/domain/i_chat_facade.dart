import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

abstract class IChatFacade {
  Future<Either<String, List<Chat?>>> getChatMessages(
    Uid<Broadcast> broadcastId,
  );
}
