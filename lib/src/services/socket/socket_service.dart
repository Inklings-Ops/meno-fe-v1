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
import 'package:meno_fe_v1/src/services/socket/socket_event.dart';
import 'package:meno_fe_v1/src/services/socket/socket_state.dart';
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
      socket = io.io(
        Env.menoApiUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'token': token?.getOr()})
            .enableAutoConnect()
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
        final decodedData =
            jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastParticipantDto.fromJson(decodedData);
        _event.add(SocketEvent.newBroadcastListener(dto.toDomain));
      })
      ..on('numberOfLiveListeners', (data) {
        final value = jsonDecode(jsonEncode(data)) as int;
        _event.add(SocketEvent.numberOfLiveListeners(value));
      })
      ..on('endedBroadcast', (data) {
        final decodedData =
            jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastDto.fromJson(decodedData);
        _event.add(SocketEvent.endedBroadcast(dto.toDomain));
      })
      ..on('newBroadcast', (data) {
        final decodedData =
            jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastDto.fromJson(decodedData);
        _event.add(SocketEvent.newBroadcast(dto.toDomain));
      })
      ..on('notification', (data) {
        final decodedData =
            jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = NotificationDto.fromJson(decodedData);
        _event.add(SocketEvent.notification(dto.toDomain));
      })
      ..on('newMessage', (data) {
        final decodedData =
            jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = ChatDto.fromJson(decodedData);
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
        ack: (_) => _state.add(const SocketBroadcastStarted()),
      ),
      joinBroadcast: (broadcastId) => emitWithAck(
        'joinBroadcast',
        {'broadcastId': broadcastId},
        ack: (_) => _state.add(const SocketBroadcastJoined()),
      ),
      leaveBroadcast: (broadcastId) => emitWithAck(
        'leaveBroadcast',
        {'broadcastId': broadcastId},
      ),
      getLiveBroadcast: (broadcastId) => emitWithAck(
        'getLiveBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = res as Map<String, dynamic>;
          final error = response['error'] as dynamic;
          final json = response['data'] as Map<String, dynamic>;
          final broadcast = BroadcastDto.fromJson(json).toDomain;
          _state.add(SocketLiveBroadcastReceived(broadcast, error));
        },
      ),
      getLiveBroadcasts: () => emitWithAck(
        'getLiveBroadcasts',
        {},
        ack: (dynamic res) {
          final response = res as Map<String, dynamic>;
          final error = response['error'] as dynamic;
          final list = response['data'] as List<Map<String, dynamic>>?;
          if (list == null || list.isEmpty) {
            _state.add(SocketLiveBroadcastsReceived([], error));
          } else {
            final dtos = list.map(BroadcastDto.fromJson).toList();
            final broadcasts = dtos.map((b) => b.toDomain).toList();
            _state.add(SocketLiveBroadcastsReceived(broadcasts, error));
          }
        },
      ),
      getBroadcastListeners: (broadcastId) => emitWithAck(
        'getBroadcastListeners',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = res as Map<String, dynamic>;
          final error = response['error'] as dynamic;
          final list = response['data'] as List<Map<String, dynamic>>?;
          if (list == null || list.isEmpty) {
            _state.add(SocketBroadcastListenersReceived([], error));
          } else {
            final dtos = list.map(BroadcastParticipantDto.fromJson).toList();
            final participants = dtos.map((p) => p.toDomain).toList();
            _state.add(SocketBroadcastListenersReceived(participants, error));
          }
        },
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
      endBroadcast: (broadcastId) => emitWithAck(
        'endBroadcast',
        {'broadcastId': broadcastId},
      ),
      sendChatMessage: (senderId, broadcastId, content, createdAt) =>
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

  // void on(String event, Function(dynamic) callback) {
  //   return socket.on(event, callback);
  // }

  @override
  FutureOr<void> onDispose() {
    _event.close();
    _state.close();
    _tokenChanges.cancel();
  }
}
