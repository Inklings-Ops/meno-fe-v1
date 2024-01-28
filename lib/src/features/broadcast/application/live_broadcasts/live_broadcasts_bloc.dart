import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/services/socket/socket_service.dart';

import '../../domain/domain.dart';
import '../../infrastructure/dtos/dtos.dart';

part 'live_broadcasts_bloc.freezed.dart';
part 'live_broadcasts_event.dart';
part 'live_broadcasts_state.dart';

@lazySingleton
class LiveBroadcastsBloc
    extends Bloc<LiveBroadcastsEvent, LiveBroadcastsState> {
  final SocketService _socket;

  LiveBroadcastsBloc({required SocketService socket})
      : _socket = socket,
        super(const _Empty()) {
    on<_GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<_UpdateLiveBroadcasts>(_onUpdateLiveBroadcasts);
    on<_FilterBroadcasts>(_onFilterBroadcasts);

    // _socket.on(sEConnect, (_) {
    //   Logger().w(_);
    //   _socket.socket.emitWithAck(
    //     "getBroadcastListeners",
    //     {"broadcastId": "b9bf9aaa-5e13-4ca3-9606-324a9100d9f1"},
    //     binary: true,
    //     ack: (data) => Future.delayed(const Duration(seconds: 2), () {
    //       Logger().w('WAITING');
    //       add(_FilterBroadcasts(data));
    //     }),
    //   );
    // });
    // _socket.on(sENewBroadcast, (data) => add(_UpdateLiveBroadcasts(data)));
    // _socket.on(sEEndedBroadcast, (_) => add(const _GetLiveBroadcasts()));
  }

  _onFilterBroadcasts(_FilterBroadcasts event, emit) {
    Logger().w('event.data');
    Logger().w(event.data);

    // final result = jsonDecode(jsonEncode(event.data))['data'];

    // final list = (result as List);

    // if (list.isEmpty) {
    //   return emit(const _Success([]));
    // } else {
    //   final dtos = list.map((b) => BroadcastDto.fromJson(b)).toList();
    //   final broadcasts = dtos.map((e) => e.toDomain).toList();
    //
    //   return emit(_Success(broadcasts));
    // }
  }

  final completer = Completer();
  Future<void> _onGetLiveBroadcasts(
    _GetLiveBroadcasts event,
    Emitter<LiveBroadcastsState> emit,
  ) async =>
      Future.delayed(
        const Duration(seconds: 2),
        () => _socket.socket.emitWithAck(
          "getLiveBroadcasts",
          {},
          ack: (data) => add(_FilterBroadcasts(data)),
        ),
      );

  // await completer.future.then((d) => add(_FilterBroadcasts(d)));

  _onUpdateLiveBroadcasts(_UpdateLiveBroadcasts event, emit) async {
    if (state is _Success) {
      final decodedData = jsonDecode(jsonEncode(event.data));
      final dto = BroadcastDto.fromJson(decodedData);

      final success = (state as _Success);
      final liveBroadcasts = List<Broadcast?>.from(success.broadcasts);
      liveBroadcasts.add(dto.toDomain);
      emit(_Success(liveBroadcasts));
    }
  }
}
//
// List<Broadcast?> _filterBroadcasts(List<Broadcast?> broadcasts, String userId) {
//   if (broadcasts.isEmpty) return [];
//
//   // Create a HashMap or LinkedHashMap to store the filtered broadcasts
//   final filteredBroadcastsMap = HashMap<String, Broadcast>();
//
//   // Filter broadcasts and add to the map
//   for (final broadcast in broadcasts) {
//     if (broadcast!.creator!.id != userId) {
//       filteredBroadcastsMap[broadcast.id] = broadcast;
//     }
//   }
//
//   // Convert the map back to a list
//   final filteredBroadcastsList = filteredBroadcastsMap.values.toList();
//   return filteredBroadcastsList;
// }
//
// Future<List<Broadcast?>> _runIsolate(
//   RootIsolateToken rToken,
//   List<Broadcast?> broadcasts,
// ) async {
//   final facade = di<IAuthFacade>();
//   final userId = (await facade.credential)!.user.id;
//   BackgroundIsolateBinaryMessenger.ensureInitialized(rToken);
//   return Isolate.run(() => _filterBroadcasts(broadcasts, userId));
// }
