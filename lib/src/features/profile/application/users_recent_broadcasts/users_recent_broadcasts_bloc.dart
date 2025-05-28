import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

part 'users_recent_broadcasts_event.dart';
part 'users_recent_broadcasts_state.dart';

const _size = 6;

class UsersRecentBroadcastsBloc
    extends Bloc<UsersRecentBroadcastsEvent, UsersRecentBroadcastsState> {
  UsersRecentBroadcastsBloc({
    required IBroadcastFacade facade,
    required ID? userId,
  })  : _facade = facade,
        _userId = userId,
        super(const UsersRecentBroadcastsLoadInProgress()) {
    on<UsersRecentBroadcastsFetchRequested>(
      _onUsersRecentBroadcastsFetchRequested,
    );
    on<UsersRecentBroadcastsFetchMoreRequested>(
      _onUsersRecentBroadcastsFetchMoreRequested,
    );
  }

  final IBroadcastFacade _facade;
  final ID? _userId;

  Future<void> _onUsersRecentBroadcastsFetchRequested(
    UsersRecentBroadcastsFetchRequested event,
    Emitter<UsersRecentBroadcastsState> emit,
  ) async {
    if (_userId == null) {
      const exception = BroadcastExceptionWithMessage('No user provided.');
      emit(const UsersRecentBroadcastsLoadFailure(exception));
    }

    emit(const UsersRecentBroadcastsLoadInProgress());

    final result = await _facade.getBroadcasts(
      creatorId: _userId,
      size: _size,
      sortBy: 'endTime',
      orderBy: OrderBy.DESC,
      endTimeExist: true,
    );

    return emit(
      result.fold(
        UsersRecentBroadcastsLoadFailure.new,
        (success) => success.items.isEmpty
            ? const UsersRecentBroadcastsEmpty()
            : UsersRecentBroadcastsLoadSuccess(
                broadcasts: success.items,
                currentPage: success.currentPage,
              ),
      ),
    );
  }

  Future<void> _onUsersRecentBroadcastsFetchMoreRequested(
    UsersRecentBroadcastsFetchMoreRequested event,
    Emitter<UsersRecentBroadcastsState> emit,
  ) async {
    if (state is UsersRecentBroadcastsLoadSuccess) {
      final loadedState = state as UsersRecentBroadcastsLoadSuccess;

      emit(UsersRecentBroadcastsLoadMoreInProgress(loadedState.broadcasts));

      final result = await _facade.getBroadcasts(
        creatorId: _userId,
        size: _size,
        sortBy: 'endTime',
        orderBy: OrderBy.DESC,
        endTimeExist: true,
        page: loadedState.currentPage + 1,
      );

      return emit(
        result.fold(
          UsersRecentBroadcastsLoadFailure.new,
          (success) {
            if (success.currentPage < success.totalPages) {
              return UsersRecentBroadcastsLoadSuccess(
                broadcasts: [...loadedState.broadcasts, ...success.items],
                currentPage: success.currentPage,
              );
            } else {
              return UsersRecentBroadcastsLoadLastSuccess(
                loadedState.broadcasts,
              );
            }
          },
        ),
      );
    }
  }
}
