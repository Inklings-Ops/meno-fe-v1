import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/env/env.dart';
import '../../features/auth/domain/domain.dart';

@injectable
class SocketService extends Object with Disposable {
  late io.Socket socket;

  final IAuthFacade _facade;

  late StreamSubscription<UserToken?> _tokenChanges;

  SocketService({required IAuthFacade facade})
      : _facade = facade,
        super() {
    socket = io.io(
      Env.menoApiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
  }

  @PostConstruct(preResolve: true)
  Future<void> initialize([Function? addListeners]) async {
    final token = (await _facade.credential)?.token;

    if (token != null) {
      socket.io.options?['token'] = {'token': token};
      socket.connect();
      socket.onConnect((data) => getLiveBroadcasts());
    }

    _responseChanges = response.stream.listen((event) {
      Logger().w(event);
    });
  }

  //
  final completer = Completer<dynamic>();
  Future<dynamic> emitWithAck(
    String event, [
    Map<String, dynamic> data = const {},
  ]) async {
    try {
      if (socket.connected == false) {
        Logger().w('Socket is not connected. Unable to emit $event');
        return null;
      }

      socket.emitWithAck(event, data, ack: completer.complete);

      return await completer.future;
    } catch (error) {
      Logger().w('Error during emitWithAck: $error');
      return null;
    }
  }
  //
  // void emitWithAck(
  //   String event, [
  //   Map<String, dynamic> data = const {},
  //   Function(dynamic)? ack,
  // ]) =>
  //     socket.emitWithAck(event, data, ack: ack);

  // void on(String event, Function(dynamic) callback) {
  //   socket.on(event, callback);
  // }

  late StreamSubscription<dynamic> _responseChanges;

  final response = StreamController<dynamic>();
  StreamSink<dynamic> get sink => response.sink;

  void getLiveBroadcasts() {
    sink.add('GETTING LIVE BROADCASTS');

    socket.emitWithAck(
      "startedBroadcasts",
      {"broadcastId": "b9bf9aaa-5e13-4ca3-9606-324a9100d9f1"},
      ack: sink.add,
    );

    sink.add('DONE');
  }

  @override
  FutureOr onDispose() async {
    await _tokenChanges.cancel();
  }
}
