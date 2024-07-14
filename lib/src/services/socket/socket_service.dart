import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/services/meno/meno_bloc.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/env/env.dart';
import '../../features/auth/domain/domain.dart';
import 'event_names.dart';

@injectable
class SocketService extends Object with Disposable {
  late io.Socket socket;

  final IAuthFacade _facade;

  late StreamSubscription<Token?> _tokenChanges;

  final _numberOfLiveParticipantsController = StreamController<int>();
  // Stream<int> get numberOfLiveParticipantsStream {
  //   return _numberOfLiveParticipantsController.stream;
  // }

  SocketService({required IAuthFacade facade}) : _facade = facade;

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
    socket.on('connect', onConnect);
    socket.on(
      sEEndedBroadcast,
      (_) => MenoBloc().add(const MenoStateChanged(MenoState.endedBroadcast())),
    );
    socket.on(sENumberOfLiveListeners, (data) {
      final number = jsonDecode(jsonEncode(data));
      _numberOfLiveParticipantsController.add(number);
    });
  }

  dynamic onConnect(_) => Logger().i('Socket Connected');

  void emitWithAck(
    String event,
    Map<String, dynamic> data, {
    Function(dynamic)? ack,
  }) {
    return socket.emitWithAck(event, data, ack: ack);
  }

  void on(String event, Function(dynamic) callback) {
    return socket.on(event, callback);
  }

  Stream<int> liveBroadcastParticipants(String broadcastId) {
    socket.emitWithAck(
      sEGetNumberOfBroadcastListeners,
      {'broadcastId': broadcastId},
      ack: (data) {
        final number = jsonDecode(jsonEncode(data))['data'];
        _numberOfLiveParticipantsController.add(number);
      },
    );
    return _numberOfLiveParticipantsController.stream;
  }

  @override
  FutureOr onDispose() {
    _tokenChanges.cancel();
  }
}
