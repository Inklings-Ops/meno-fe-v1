// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:collection';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:rxdart/rxdart.dart';

part 'participants_bloc.freezed.dart';

part 'participants_event.dart';

part 'participants_state.dart';

class ParticipantsBloc extends Bloc<ParticipantsEvent, ParticipantsState> {
  ParticipantsBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(ParticipantsState.initial()) {
    on<GetLiveParticipants>(_onGetLiveParticipants);
    on<ParticipantsReloadPressed>(_onParticipantsReloadPressed);
    on<GetAllParticipants>(_onGetAllParticipants);
    on<ParticipantsReset>(_onParticipantsReset);
    on<ParticipantJoined>(_onParticipantJoined, transformer: _transformer());
    on<ParticipantLeft>(_onParticipantLeft, transformer: _transformer());
  }

  final IBroadcastFacade _facade;

  final _initialState = ParticipantsState.initial();

  /// Priority bucket for [Role.host]. This is not a list as there will be only
  /// one host broadcast
  BroadcastParticipant? host;

  /// Priority bucket for [Role.cohost]
  final LinkedHashSet<BroadcastParticipant> cohosts = LinkedHashSet();

  /// Priority bucket for [Role.listener]
  final LinkedHashSet<BroadcastParticipant> listeners = LinkedHashSet();

  /// Tracks the initialization state of the Streams
  bool _listenersInitialized = false;

  /// Initialization event for the [ParticipantsBloc]
  ///
  /// This will
  /// - Store the live broadcast object gotten from the event parameter
  /// - Retrieve all the currently live participants and update the state
  Future<void> _onGetLiveParticipants(
    GetLiveParticipants event,
    Emitter<ParticipantsState> emit,
  ) async {
    if (_listenersInitialized) return;

    // Retrieve all the currently live participants from the backend
    final response = await _facade.liveListeners(event.broadcastId);

    emit(
      response.fold(
        (exception) => state.copyWith(loading: false, exception: exception),
        (participants) {
          _initializeBuckets(participants);
          return state.copyWith(
            liveParticipants: _buildSortedList(),
            numberOfLiveParticipants: _participantCount,
            loading: false,
          );
        },
      ),
    );

    _listenersInitialized = true;
  }

  /// Reload event to retrieve all the currently live [BroadcastParticipant]s
  Future<void> _onParticipantsReloadPressed(
    ParticipantsReloadPressed event,
    Emitter<ParticipantsState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final response = await _facade.liveListeners(event.broadcastId);
    emit(
      response.fold(
        (exception) => state.copyWith(loading: false, exception: exception),
        (participants) {
          _initializeBuckets(participants);
          return state.copyWith(
            liveParticipants: _buildSortedList(),
            numberOfLiveParticipants: _participantCount,
            loading: false,
          );
        },
      ),
    );
  }

  /// Fetches all the [BroadcastParticipant]s that have joined the broadcast
  /// from the time it started to its ending
  Future<void> _onGetAllParticipants(
    GetAllParticipants event,
    Emitter<ParticipantsState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final response = await _facade.listeners(event.broadcastId);
    emit(
      response.fold(
        (exception) => state.copyWith(loading: false, exception: exception),
        (participants) => state.copyWith(
          allParticipants: participants,
          numberOfAllParticipants: participants.length,
          loading: false,
        ),
      ),
    );
  }

  /// Event function to update the state when a new [BroadcastParticipant]
  /// joins a [Broadcast]
  void _onParticipantJoined(
    ParticipantJoined event,
    Emitter<ParticipantsState> emit,
  ) {
    if (!_listenersInitialized) return;
    _addToBucket(event.participant);
    emit(
      state.copyWith(
        liveParticipants: _buildSortedList(),
        numberOfLiveParticipants: _participantCount,
      ),
    );
  }

  /// Event function to update the state when a [BroadcastParticipant] leaves
  /// a [Broadcast]
  void _onParticipantLeft(
    ParticipantLeft event,
    Emitter<ParticipantsState> emit,
  ) {
    if (!_listenersInitialized) return;
    _removeFromBucket(event.participant);
    emit(
      state.copyWith(
        liveParticipants: _buildSortedList(),
        numberOfLiveParticipants: _participantCount,
      ),
    );
  }

  /// Event function to reset the [ParticipantsBloc] and free up resources
  void _onParticipantsReset(
    ParticipantsReset event,
    Emitter<ParticipantsState> emit,
  ) {
    _listenersInitialized = false;
    host = null;
    cohosts.clear();
    listeners.clear();
    emit(_initialState);
  }

  void _addToBucket(BroadcastParticipant participant) {
    switch (participant.role) {
      case Role.host || Role.HOST:
        host = participant;
        return;
      case Role.cohost || Role.COHOST:
        cohosts.add(participant);
        return;
      case Role.listener || Role.LISTENER:
        listeners.add(participant);
        return;
      case null:
        return;
    }
  }

  void _removeFromBucket(BroadcastParticipant participant) {
    switch (participant.role) {
      case Role.host || Role.HOST:
        if (host?.id == participant.id) host = null;
        return;
      case Role.cohost || Role.COHOST:
        cohosts.remove(participant);
        return;
      case Role.listener || Role.LISTENER:
        listeners.remove(participant);
        return;
      case null:
        return;
    }
  }

  void _initializeBuckets(List<BroadcastParticipant> participants) {
    host = null;
    cohosts.clear();
    listeners.clear();

    for (final participant in participants) {
      _addToBucket(participant);
    }
  }

  List<BroadcastParticipant> _buildSortedList() {
    return [
      if (host != null) host!,
      ...cohosts,
      ...listeners,
    ];
  }

  int get _participantCount =>
      (host != null ? 1 : 0) + cohosts.length + listeners.length;

  EventTransformer<E> _transformer<E>() {
    return (events, mapper) => events
        .bufferTime(const Duration(milliseconds: 350))
        .expand((batch) => batch)
        .asyncExpand(mapper);
  }
}
