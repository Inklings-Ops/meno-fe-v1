import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'users_all_broadcasts_bloc.freezed.dart';
part 'users_all_broadcasts_event.dart';
part 'users_all_broadcasts_state.dart';

const _size = 6;

class UsersAllBroadcastsBloc
    extends Bloc<UsersAllBroadcastsEvent, UsersAllBroadcastsState> {
  UsersAllBroadcastsBloc({
    required IBroadcastFacade facade,
    required Uid<User> userId,
  })  : _facade = facade,
        _userId = userId,
        super(const UsersAllBroadcastsLoading()) {
    on<GetUsersBroadcasts>(_onGetUsersBroadcasts);
    on<GetMoreUsersBroadcasts>(_onGetMoreUsersBroadcasts);
  }

  final IBroadcastFacade _facade;
  final Uid<User> _userId;

  Future<void> _onGetUsersBroadcasts(
    GetUsersBroadcasts event,
    Emitter<UsersAllBroadcastsState> emit,
  ) async {
    emit(const UsersAllBroadcastsLoading());

    final result = await _facade.getBroadcasts(
      creatorId: _userId.getOr(),
      size: _size,
      sortBy: 'endTime',
      orderBy: 'DESC',
      page: 1,
    );

    return emit(
      result.fold(
        UsersAllBroadcastsFailure.new,
        (success) => success.broadcasts.isEmpty
            ? const UsersAllBroadcastsEmpty()
            : UsersAllBroadcastsLoaded(success.broadcasts),
      ),
    );
  }

  Future<void> _onGetMoreUsersBroadcasts(
    GetMoreUsersBroadcasts event,
    Emitter<UsersAllBroadcastsState> emit,
  ) async {
    if (state is UsersAllBroadcastsLoaded) {
      final loadedState = state as UsersAllBroadcastsLoaded;

      emit(UsersAllBroadcastsLoadingMore(loadedState.broadcasts));

      final result = await _facade.getBroadcasts(
        creatorId: _userId.getOr(),
        size: _size,
        sortBy: 'endTime',
        orderBy: 'DESC',
        page: loadedState.broadcasts.length ~/ _size + 1,
      );

      return emit(
        result.fold(
          UsersAllBroadcastsFailure.new,
          (success) {
            if (success.broadcasts.isEmpty) {
              return UsersAllBroadcastsLoadedLast(loadedState.broadcasts);
            } else {
              return UsersAllBroadcastsLoaded([
                ...loadedState.broadcasts,
                ...success.broadcasts,
              ]);
            }
          },
        ),
      );
    }
  }
}
