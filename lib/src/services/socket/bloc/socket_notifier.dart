// import 'dart:async';
//
// import 'package:logger/logger.dart';
// import 'package:meno_fe_v1/src/core/env/env.dart';
// import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
// import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
//
// part 'socket_notifier.g.dart';
//
// @Riverpod(keepAlive: true)
// IAuthFacade auth(AuthRef ref) => di<IAuthFacade>();
//
// @Riverpod(keepAlive: true)
// Stream<UserToken?> token(TokenRef ref) async* {
//   final controller = StreamController<UserToken?>();
//   ref.watch(authProvider).tokenChanges.listen(controller.add);
//   ref.onDispose(controller.close);
//   yield* controller.stream;
// }
//
// // @riverpod
// // Stream<dynamic> socketStream(SocketStreamRef ref) {}
//
// @Riverpod(keepAlive: true)
// Stream liveBroadcasts(LiveBroadcastsRef ref) {
//   final controller = StreamController<dynamic>();
//
//   ref.watch(socketProvider)?.emitWithAck('getLiveBroadcasts', {}, ack: (data) {
//     controller.add(data);
//     // final result = jsonDecode(jsonEncode(data))['data'];
//     // final list = (result as List);
//
//     // if (list.isEmpty) {
//     //   controller.add([]);
//     // } else {
//     //   final dtos = list.map((b) => BroadcastDto.fromJson(b)).toList();
//     //   final broadcasts = dtos.map((e) => e.toDomain).toList();
//
//     //   controller.add(broadcasts);
//     // }
//   });
//
//   controller.stream.listen(Logger().w);
//
//   // ref.onDispose(controller.close);
//   return controller.stream;
// }
//
// @Riverpod(keepAlive: true)
// io.Socket? socket(SocketRef ref) {
//   late io.Socket socket;
//   final token = ref.watch(tokenProvider).value;
//   if (token == null) return null;
//
//   socket = io.io(
//     Env.menoApiUrl,
//     io.OptionBuilder()
//         .setTransports(['websocket'])
//         .setQuery({'token': token})
//         .enableAutoConnect()
//         .build(),
//   );
//
//   socket.onConnect((_) {
//     Logger().f('SocketClient actively connected');
//   });
//
//   return socket;
// }
