import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class ChatRepositoryImpl with MenoLogger implements IChatRepository {
  const ChatRepositoryImpl({required ChatRemoteDataSource remote})
    : _remote = remote;

  final ChatRemoteDataSource _remote;

  @override
  Future<Either<MenoException, Unit>> deleteMessage(
    DeleteMessageParams params,
  ) async {
    try {
      await _remote.emitDeleteMessage(params);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> editMessage(
    EditMessageParams params,
  ) async {
    try {
      await _remote.emitEditMessage(params);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> sendMessage(
    NewMessageParams params,
  ) async {
    try {
      await _remote.emitSendChatMessage(params);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Stream<List<Message>> watchChatMessages(Id broadcastId) {
    late StreamController<List<Message>> controller;
    final messages = ListNotifier<Message>();

    void emit() => controller.add(messages);

    Future<void> initialFetch() async {
      try {
        final response = await _remote.getMessages(broadcastId.getOrCrash());
        final json = response as Map<String, dynamic>;
        final items = json['chatMessages'] as List<dynamic>;
        final dtos = items.map(MessageDto.fromJson).toList();
        final domainList = dtos.map((e) => e.toDomain).toList();
        messages.startTransAction();
        messages.clear();
        messages.addAll(domainList);
        messages.endTransAction();
        emit();
      } catch (e, stackTrace) {
        log.e('ChatRepository: Failed to fetch messages - $e');
        log.e('Stack trace: $stackTrace');
        controller.addError(e);
      }
    }

    StreamSubscription? newMessageSubscription;
    StreamSubscription? editedMessageSubscription;
    StreamSubscription? deletedMessageSubscription;

    controller = StreamController<List<Message>>.broadcast(
      onListen: () async {
        log.d('ChatRepository: Stream listener attached');

        await initialFetch();
        final id = broadcastId.getOrCrash();

        newMessageSubscription = _remote.onNewMessage(id).listen((dto) {
          log.d('New Message from ${dto.fullName}: ${dto.content}');
          messages.add(dto.toDomain);
          emit();
        });

        editedMessageSubscription = _remote.onEditedMessage(id).listen((dto) {
          log.d('Edited Message from ${dto.fullName}: ${dto.content}');
          final index = messages.indexWhere((m) => m.id.getOrCrash() == dto.id);
          if (index == -1) return;
          messages[index] = dto.toDomain;
          emit();
        });

        deletedMessageSubscription = _remote.onDeletedMessage(id).listen((dto) {
          log.d('Deleted Message from ${dto.fullName}: ${dto.content}');
          messages.removeWhere((m) => m.id.getOrCrash() == dto.id);
          emit();
        });
      },
      onCancel: () {
        log.d('ChatRepository: Stream listener detached');

        newMessageSubscription?.cancel();
        editedMessageSubscription?.cancel();
        deletedMessageSubscription?.cancel();
        messages.dispose();
      },
    );

    return controller.stream;
  }
}
