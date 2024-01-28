import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../dependency_injector/injector.dart';
import '../../../features/auth/domain/domain.dart';
import '../../../features/broadcast/domain/domain.dart';
import '../event_names.dart';
import '../socket_service.dart';

part 'socket_bloc.freezed.dart';
part 'socket_event.dart';
part 'socket_state.dart';

@injectable
class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final SocketService _service;

  SocketBloc({required SocketService socketService})
      : _service = socketService,
        super(const _Disconnected()) {
    on<_Connect>(_onConnect);
    on<_Disconnect>(_onDisconnect);
    on<_GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<_GetLiveParticipants>(_onGetLiveParticipants);
    on<_NewBroadcast>(_newBroadcast);
    on<_NumberOfLiveListeners>(_numberOfLiveListeners);
    on<_EndedBroadcast>(_endedBroadcast);
    on<_NewBroadcastListener>(_newBroadcastListener);
    on<_LeaveBroadcast>(_onLeaveBroadcast);
  }

  _onConnect(_, emit) => emit(const _Connected());
  _onDisconnect(_, emit) => emit(const _Disconnected());
  _onLeaveBroadcast(_, emit) {}
  _onGetLiveBroadcasts(_, emit) async {
    emit(const _Loading());
    // await _service.emit(sEGetLiveBroadcasts, {}).then(
    //     (data) => emit(_LiveBroadcastsData(data)));
  }

  _onGetLiveParticipants(_GetLiveParticipants event, emit) {
    _service.socket?.emitWithAck(
      sEGetBroadcastListeners,
      {'broadcastId': event.broadcastId},
      ack: (data) {
        Logger().f(data);
        emit(_LiveListenersData(data));
      },
    );
  }

  _newBroadcast(event, emit) => emit(_NewBroadcastData(event.data));

  _newBroadcastListener(event, emit) {
    emit(_NewBroadcastListenerData(event.data));
  }

  _numberOfLiveListeners(event, emit) {
    Logger().w('WOWOWOWOWOW');
    emit(_NumberOfLiveListenersData(event.data));
  }

  _endedBroadcast(_, emit) => emit(const _EndedBroadcastData());

  @PostConstruct(preResolve: true)
  Future<void> init() async {}

  void setupListeners() {
    // _service.socket?.on(
    //   'newBroadcastListener',
    //   (data) {
    //     Logger().f('NEW BROADCAST LISTENERS => $data');
    //     // add(_NewBroadcastListener(data));
    //   },
    // );
    // _service.socket?.on(
    //   sENumberOfLiveListeners,
    //   (data) {
    //     Logger().f('NUMBER OF LIVE LISTENERS => $data');
    //     // add(_NumberOfLiveListeners(data));
    //   },
    // );
    // _service.on(sEDisconnect, (_) => Logger().w('Socket disconnected'));
    // _service.on(
    //   sEConnect,
    //   (_) {
    //     // Logger().f('THIS IS HOME');
    //     // add(const _GetLiveBroadcasts());
    //   },
    // );
    // // _service.on(
    // //   sENewBroadcast,
    // //   (data) => add(_NewBroadcast(data)),
    // // );
    //
    // _service.on(sEEndedBroadcast, (_) {
    //   add(_EndedBroadcast(_));
    //   add(const _GetLiveBroadcasts());
    // });
  }
}

List<Broadcast?> _filterBroadcasts(List<Broadcast?> broadcasts, String userId) {
  if (broadcasts.isEmpty) return [];

  // Create a HashMap or LinkedHashMap to store the filtered broadcasts
  final filteredBroadcastsMap = HashMap<String, Broadcast>();

  // Filter broadcasts and add to the map
  for (final broadcast in broadcasts) {
    if (broadcast!.creator!.id != userId) {
      filteredBroadcastsMap[broadcast.id] = broadcast;
    }
  }

  // Convert the map back to a list
  final filteredBroadcastsList = filteredBroadcastsMap.values.toList();
  return filteredBroadcastsList;
}

Future<List<Broadcast?>> _runIsolate(
  RootIsolateToken rToken,
  List<Broadcast?> broadcasts,
) async {
  final facade = di<IAuthFacade>();
  final userId = (await facade.credential)!.user.id;
  BackgroundIsolateBinaryMessenger.ensureInitialized(rToken);
  return Isolate.run(() => _filterBroadcasts(broadcasts, userId));
}
