import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

abstract class IChatRepository implements Disposable {
  List<Message> get messages;

  Future<Either<MenoException, Unit>> sendMessage(NewMessageParams params);

  Future<Either<MenoException, Unit>> editMessage(EditMessageParams params);

  Future<Either<MenoException, Unit>> deleteMessage(DeleteMessageParams params);

  Stream<List<Message>> watchMessages(Id broadcastId);
}
