import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

abstract class IChatRepository implements Disposable {
  bool get canFetchMore;

  Future<Either<MenoException, Unit>> sendMessage(NewMessageParams params);

  Future<Either<MenoException, Unit>> editMessage(EditMessageParams params);

  Future<Either<MenoException, Unit>> deleteMessage(DeleteMessageParams params);

  /// The primary reactive stream. Emits the full current list on every change.
  Stream<List<Message>> watchMessages(Id broadcastId);

  /// Fetches the next page of older messages and emits through [watchMessages].
  Future<Either<MenoException, Unit>> fetchOlderMessages(Id broadcastId);
}
