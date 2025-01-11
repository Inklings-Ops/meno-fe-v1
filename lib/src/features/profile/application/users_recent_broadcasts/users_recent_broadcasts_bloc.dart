import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

part 'users_recent_broadcasts_bloc.freezed.dart';
part 'users_recent_broadcasts_event.dart';
part 'users_recent_broadcasts_state.dart';

const _size = 6;

class UsersRecentBroadcastsBloc
    extends Bloc<UsersRecentBroadcastsEvent, UsersRecentBroadcastsState> {
  UsersRecentBroadcastsBloc({
    required IBroadcastFacade facade,
    required Uid<User> userId,
  })  : _facade = facade,
        _userId = userId,
        super(const UsersRecentBroadcastsLoading()) {
    on<GetUsersRecentBroadcasts>(_onGetUsersRecentBroadcasts);
    on<GetMoreUsersRecentBroadcasts>(_onGetMoreUsersRecentBroadcasts);
  }

  final IBroadcastFacade _facade;
  final Uid<User> _userId;

  Future<void> _onGetUsersRecentBroadcasts(
    GetUsersRecentBroadcasts event,
    Emitter<UsersRecentBroadcastsState> emit,
  ) async {
    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 100));

    emit(const UsersRecentBroadcastsLoading());

    final result = await _facade.getBroadcasts(
      creatorId: _userId.getOr(),
      size: _size,
      sortBy: 'endTime',
      orderBy: 'DESC',
      page: 1,
      endTimeExist: true,
      endTimeGT: oneDayAgo.toIso8601String(),
      endTimeLT: now.toIso8601String(),
    );

    return emit(
      result.fold(
        UsersRecentBroadcastsFailure.new,
        (success) => success.broadcasts.isEmpty
            ? const UsersRecentBroadcastsEmpty()
            : UsersRecentBroadcastsLoaded(success.broadcasts),
      ),
    );
  }

  Future<void> _onGetMoreUsersRecentBroadcasts(
    GetMoreUsersRecentBroadcasts event,
    Emitter<UsersRecentBroadcastsState> emit,
  ) async {
    if (state is UsersRecentBroadcastsLoaded) {
      final loadedState = state as UsersRecentBroadcastsLoaded;

      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 100));

      emit(UsersRecentBroadcastsLoadingMore(loadedState.broadcasts));

      final result = await _facade.getBroadcasts(
        creatorId: _userId.getOr(),
        size: _size,
        sortBy: 'endTime',
        orderBy: 'DESC',
        endTimeExist: true,
        page: loadedState.broadcasts.length ~/ _size + 1,
        endTimeGT: oneDayAgo.toIso8601String(),
        endTimeLT: now.toIso8601String(),
      );

      return emit(
        result.fold(
          UsersRecentBroadcastsFailure.new,
          (success) {
            if (success.broadcasts.isEmpty) {
              return UsersRecentBroadcastsLoadedLast(loadedState.broadcasts);
            } else {
              return UsersRecentBroadcastsLoaded([
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
