import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/infrastructure/dtos/chat_dto.dart';
import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_dto.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@injectable
class SocketService extends Object with Disposable {
  SocketService({required IAuthFacade facade}) : _facade = facade;
  final IAuthFacade _facade;
  late io.Socket socket;
  late StreamSubscription<Token?> _tokenChanges;

  final _event = BehaviorSubject<SocketEvent>();
  final _state = BehaviorSubject<SocketState>();

  Stream<SocketEvent> get eventsStream => _event.stream.asBroadcastStream();
  Stream<SocketState> get stateStream => _state.stream.asBroadcastStream();

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    _tokenChanges = _facade.tokenChanges.listen((token) {
      if (token?.isValid == false) return;
      socket = io.io(
        Env.menoApiUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'token': token?.getOr()})
            .enableAutoConnect()
            .enableReconnection()
            .build(),
      );
      setupListeners();
    });
  }

  void setupListeners() {
    socket
      ..on('connect', onConnect)
      ..on('numberOfLiveBroadcasts', (data) {
        final value = jsonDecode(jsonEncode(data)) as int;
        _event.add(SocketEvent.numberOfLiveBroadcasts(value));
      })
      ..on('newBroadcastListener', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastParticipantDto.fromJson(decoded);
        _event.add(SocketEvent.newBroadcastListener(dto.toDomain));
      })
      ..on('broadcastListenerLeft', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastParticipantDto.fromJson(decoded);
        _event.add(SocketEvent.newBroadcastListener(dto.toDomain));
      })
      ..on('endedBroadcast', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = EndedBroadcastDataDto.fromJson(decoded);
        _event.add(SocketEvent.endedBroadcast(dto.toDomain));
      })
      ..on('newBroadcast', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastDto.fromJson(decoded);
        _event.add(SocketEvent.newBroadcast(dto.toDomain));
      })
      ..on('hostDisconnected', (data) {
        final value = jsonDecode(jsonEncode(data)) as bool;
        _event.add(SocketEvent.hostDisconnected(value: value));
      })
      ..on('hostReconnected', (data) {
        final value = jsonDecode(jsonEncode(data)) as bool;
        _event.add(SocketEvent.hostReconnected(value: value));
      })
      ..on('notification', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = NotificationDto.fromJson(decoded);
        _event.add(SocketEvent.notification(dto.toDomain));
      })
      ..on('newMessage', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = ChatDto.fromJson(decoded);
        _event.add(SocketEvent.newMessage(dto.toDomain));
      });
  }

  dynamic onConnect(_) => Logger().i('Socket Connected');

  void emitWithAck(
    String event,
    Map<String, dynamic> data, {
    Function? ack,
  }) {
    return socket.emitWithAck(event, data, ack: ack);
  }

  void emit(SocketEvent event) {
    event.whenOrNull(
      startedBroadcast: (broadcastId) => emitWithAck(
        'startedBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = SocketResponse.fromJson(
            res as Map<String, dynamic>,
            (json) => json as dynamic,
          );
          _state.add(SocketBroadcastStarted(error: response.error));
        },
      ),
      joinBroadcast: (broadcastId) => emitWithAck(
        'joinBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = SocketResponse.fromJson(
            res as Map<String, dynamic>,
            (json) => json as dynamic,
          );
          _state.add(SocketBroadcastJoined(error: response.error));
        },
      ),
      leaveBroadcast: (broadcastId) => emitWithAck(
        'leaveBroadcast',
        {'broadcastId': broadcastId},
      ),
      endBroadcast: (broadcastId) => emitWithAck(
        'endBroadcast',
        {'broadcastId': broadcastId},
      ),
      getNumberOfLiveBroadcasts: () => emitWithAck(
        'getNumberOfLiveBroadcasts',
        {},
      ),
      getNumberOfBroadcastListeners: (broadcastId) => emitWithAck(
        'getNumberOfBroadcastListeners',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = res as Map<String, dynamic>;
          final error = response['error'] as dynamic;
          final value = jsonDecode(jsonEncode(response['data'])) as int;
          _state.add(SocketNumberOfBroadcastListenersReceived(value, error));
        },
      ),
      sendChatMessage: (
        senderId,
        broadcastId,
        content,
        createdAt,
      ) =>
          emitWithAck(
        'sendChatMessage',
        {
          'senderId': senderId,
          'broadcastId': broadcastId,
          'content': content,
          'createdAt': createdAt,
        },
      ),
      getChatMessages: (broadcastId) => emitWithAck(
        'getChatMessages',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = res as Map<String, dynamic>;
          final data = response['data'] as Map<String, dynamic>;
          final list = data['chatMessages'] as List<Map<String, dynamic>>?;
          if (list == null || list.isEmpty) {
            _state.add(const SocketState.getChatMessages([], null));
          } else {
            final dtos = list.map(ChatDto.fromJson).toList();
            final chats = dtos.map((c) => c.toDomain).toList();
            _state.add(SocketState.getChatMessages(chats, null));
          }
        },
      ),
    );
  }

  @override
  FutureOr<void> onDispose() {
    _event.close();
    _state.close();
    _tokenChanges.cancel();
  }
}
