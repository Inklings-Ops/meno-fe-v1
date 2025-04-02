import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';
part 'subscription_bloc.freezed.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({
    required IProfileFacade facade,
    required ISessionContext session,
  })  : _facade = facade,
        _session = session,
        super(const SubscriptionState()) {
    on<Subscribe>(_onSubscribe);
    on<Unsubscribe>(_onUnsubscribe);
    on<FetchSubscribers>(_onFetchSubscribers);
    on<FetchSubscriptions>(_onFetchSubscriptions);
  }

  final IProfileFacade _facade;
  final ISessionContext _session;

  void get init {
    add(const FetchSubscribers());
    add(const FetchSubscriptions());
  }

  final Map<String, bool> subscribeMap = {};

  Future<void> _onSubscribe(
    Subscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    final user = event.user;

    subscribeMap[user.id] = true;

    emit(state.copyWith(loading: true, exception: null));
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
            loading: false,
            exception: failure,
          ),
        );
      },
      (_) => emit(state.copyWith(loading: false)),
    );
  }

  Future<void> _onUnsubscribe(
    Unsubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    subscribeMap[event.user.id] = false;
    emit(state.copyWith(loading: true, exception: null));
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
            loading: false,
            exception: failure,
          ),
        );
      },
      (_) => emit(state.copyWith(loading: false)),
    );
  }

  Future<void> _onFetchSubscribers(
    FetchSubscribers event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(loading: true, exception: null));
    final failureOrSubscribers = await _facade.getSubscribers(
      subscriptionId: _session.credential!.user.id.getOr(),
    );
    failureOrSubscribers.fold(
      (failure) => emit(state.copyWith(exception: failure, loading: false)),
      (result) => emit(
        state.copyWith(
          subscribers: result.subscribers,
          loading: false,
        ),
      ),
    );
  }

  Future<void> _onFetchSubscriptions(
    FetchSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(loading: true, exception: null));
    final failureOrSubscriptions = await _facade.getSubscriptions(
      subscriberId: _session.credential!.user.id.getOr(),
    );
    failureOrSubscriptions.fold(
      (failure) => emit(state.copyWith(exception: failure, loading: false)),
      (result) => emit(
        state.copyWith(
          subscribtions: result.subscribers,
          loading: false,
        ),
      ),
    );
  }
}
