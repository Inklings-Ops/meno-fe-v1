// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({
    required IProfileFacade facade,
    required ISessionContext session,
  })  : _facade = facade,
        _session = session,
        super(const SubscriptionState()) {
    on<SubscribeRequested>(_onSubscribeRequested);
    on<UnsubscribeRequested>(_onUnsubscribeRequested);
    on<SubscribersFetchRequested>(_onSubscribersFetchRequested);
    on<SubscriptionsFetchRequested>(_onSubscriptionsFetchRequested);
  }

  final IProfileFacade _facade;
  final ISessionContext _session;

  void get init {
    add(const SubscribersFetchRequested());
    add(const SubscriptionsFetchRequested());
  }

  final Map<ID, bool> subscribeMap = {};

  Future<void> _onSubscribeRequested(
    SubscribeRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    final user = event.user;

    subscribeMap[user.id] = true;

    emit(state.copyWith(isLoading: true, exception: null));
    final updatedSubscribers = List<Profile?>.from(state.subscribers)
      ..add(event.user);
    emit(state.copyWith(subscribers: updatedSubscribers));
    final failureOrSuccess = await _facade.subscribe(user.id);
    failureOrSuccess.fold(
      (failure) {
        subscribeMap.remove(user.id);
        emit(
          state.copyWith(
            subscribers: updatedSubscribers..remove(user),
            isLoading: false,
            exception: failure,
          ),
        );
      },
      (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> _onUnsubscribeRequested(
    UnsubscribeRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    subscribeMap[event.user.id] = false;
    emit(state.copyWith(isLoading: true, exception: null));
    final updatedSubscribers = List<Profile?>.from(state.subscribers)
      ..remove(event.user);
    emit(state.copyWith(subscribers: updatedSubscribers));
    final failureOrSuccess = await _facade.unsubscribe(event.user.id);
    failureOrSuccess.fold(
      (failure) {
        subscribeMap.remove(event.user.id);
        emit(
          state.copyWith(
            subscribers: updatedSubscribers..add(event.user),
            isLoading: false,
            exception: failure,
          ),
        );
      },
      (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> _onSubscribersFetchRequested(
    SubscribersFetchRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, exception: null));
    final failureOrSubscribers = await _facade.getSubscribers(
      subscriptionId: _session.credential!.user.id,
    );
    failureOrSubscribers.fold(
      (failure) => emit(state.copyWith(exception: failure, isLoading: false)),
      (result) => emit(
        state.copyWith(
          subscribers: result.items,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onSubscriptionsFetchRequested(
    SubscriptionsFetchRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, exception: null));
    final failureOrSubscriptions = await _facade.getSubscriptions(
      subscriberId: _session.credential!.user.id,
    );
    failureOrSubscriptions.fold(
      (failure) => emit(state.copyWith(exception: failure, isLoading: false)),
      (result) => emit(
        state.copyWith(
          subscriptions: result.items,
          isLoading: false,
        ),
      ),
    );
  }
}
