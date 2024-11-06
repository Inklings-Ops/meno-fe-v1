import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/features.dart';
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
      ..on('newBroadcastListener', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastParticipantDto.fromJson(decoded);
        _event.add(SocketEvent.newBroadcastListener(dto.toDomain));
      })
      ..on('broadcastListenerLeft', (data) {
        final decoded = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
        final dto = BroadcastParticipantDto.fromJson(decoded);
        _event.add(SocketEvent.broadcastListenerLeft(dto.toDomain));
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
          if (response.error != null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(const SocketBroadcastStarted());
          }
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
          if (response.error != null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(const SocketBroadcastJoined());
          }
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
          final response = SocketResponse<ChatListDto>.fromJson(
            res as Map<String, dynamic>,
            (json) => ChatListDto.fromJson(json as Map<String, dynamic>),
          );
          final dtos = response.data!.chatMessages;
          final chatMessages = dtos.map((chat) => chat?.toDomain).toList();
          if (response.error != null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(SocketState.getChatMessages(chatMessages));
          }
        },
      ),
      getLiveBroadcast: (broadcastId) => emitWithAck(
        'getLiveBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = SocketResponse<BroadcastDto>.fromJson(
            res as Map<String, dynamic>,
            (json) => BroadcastDto.fromJson(json as Map<String, dynamic>),
          );
          if (response.error != null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(SocketLiveBroadcastRetrieved(response.data!.toDomain));
          }
        },
      ),
    );
  }

  Future<SocketResponse<dynamic>> emitFutureWithAck(
    String event,
    Map<String, dynamic> data, {
    dynamic Function(dynamic)? ack,
  }) {
    final completer = Completer<SocketResponse<dynamic>>();
    socket.emitWithAck(
      event,
      data,
      ack: (dynamic res) {
        final socketResponse = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => json as dynamic,
        );
        completer.complete(socketResponse);
        ack?.call(res);
      },
    );
    return completer.future;
  }

  Future<SocketResponse<dynamic>> emitFuture(SocketEvent event) async {
    return event.maybeWhen(
      orElse: SocketResponse.new,
      startedBroadcast: (broadcastId) => emitFutureWithAck(
        'startedBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = SocketResponse.fromJson(
            res as Map<String, dynamic>,
            (json) => json as dynamic,
          );
          if (response.error == null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(const SocketBroadcastStarted());
          }
        },
      ),
      joinBroadcast: (broadcastId) => emitFutureWithAck(
        'joinBroadcast',
        {'broadcastId': broadcastId},
        ack: (dynamic res) {
          final response = SocketResponse.fromJson(
            res as Map<String, dynamic>,
            (json) => json as dynamic,
          );
          if (response.error == null) {
            _state.add(SocketError(response.error!));
          } else {
            _state.add(const SocketBroadcastJoined());
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
