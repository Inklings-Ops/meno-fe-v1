import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class ChatRepositoryImpl with MLogger implements IChatRepository {
  ChatRepositoryImpl({required ChatRemoteDataSource remote}) : _remote = remote;

  final ChatRemoteDataSource _remote;

  StreamController<List<Message>>? _controller;

  // Cached messages
  late final _messages = ListNotifier<Message>(data: []);

  // Pagination state for the messages
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  bool get canFetchMore => _currentPage < _totalPages;

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
  Stream<List<Message>> watchMessages(Id broadcastId) {
    StreamSubscription? newMessageSubscription;
    StreamSubscription? editedMessageSubscription;
    StreamSubscription? deletedMessageSubscription;

    Future<void> fetchPage(int page) async {
      try {
        final response = await _remote.getMessages(
          broadcastId.getOrCrash(),
          page: page,
        );

        final json = response as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final items = data['chatMessages'] as List<dynamic>;
        final dtos = items.map(MessageDto.fromJson).toList();
        final domainMessages = dtos.map((e) => e.toDomain).toList();

        _totalPages = (data['totalPages'] as num).toInt();
        _currentPage = page;

        _messages.startTransAction();
        if (page == 1) {
          _messages.clear();
          _messages.addAll(domainMessages);
        } else {
          _messages.addAll(domainMessages);
        }
        _messages.endTransAction();

        _emit();
      } catch (e, stackTrace) {
        log.e('ChatRepository: Failed to fetch messages - $e');
        log.e('Stack trace: $stackTrace');
        if (_controller?.isClosed == false) _controller?.addError(e);
      }
    }

    _controller = StreamController<List<Message>>.broadcast(
      onListen: () async {
        log.d('ChatRepository: Stream listener attached');

        await fetchPage(1);

        final id = broadcastId.getOrCrash();

        newMessageSubscription = _remote.onNewMessage(id).listen((dto) {
          log.d('New Message from ${dto.fullName}: ${dto.content}');
          _messages.insert(0, dto.toDomain);
          _emit();
        });

        editedMessageSubscription = _remote.onEditedMessage(id).listen((d) {
          log.d('Edited Message from ${d.fullName}: ${d.content}');
          final index = _messages.indexWhere((m) => m.id.getOrCrash() == d.id);
          if (index == -1) return;
          _messages[index] = d.toDomain;
          _emit();
        });

        deletedMessageSubscription = _remote.onDeletedMessage(id).listen((dto) {
          log.d('Deleted Message from ${dto.fullName}: ${dto.content}');
          _messages.removeWhere((m) => m.id.getOrCrash() == dto.id);
          _emit();
        });
      },
      onCancel: () {
        log.d('ChatRepository: Stream listener detached');

        newMessageSubscription?.cancel();
        editedMessageSubscription?.cancel();
        deletedMessageSubscription?.cancel();
      },
    );

    return _controller!.stream;
  }

  @override
  Future<Either<MenoException, Unit>> fetchOlderMessages(Id broadcastId) async {
    if (!canFetchMore) return const Right(unit);

    try {
      final response = await _remote.getMessages(
        broadcastId.getOrCrash(),
        page: _currentPage + 1,
      );

      final json = response as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final items = data['chatMessages'] as List<dynamic>;
      final dtos = items.map(MessageDto.fromJson).toList();
      final domainMessages = dtos.map((e) => e.toDomain).toList();

      _totalPages = (data['totalPages'] as num).toInt();
      _currentPage++;

      _messages.startTransAction();
      _messages.addAll(domainMessages);
      _messages.endTransAction();

      _emit();
      return const Right(unit);
    } catch (e) {
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  void _emit() {
    if (_controller != null && _controller?.isClosed == false) {
      _controller?.add(List.unmodifiable(_messages));
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('ChatRepository: Disposed');
    _messages.dispose();

    _controller?.close();
    _controller = null;
  }
}
