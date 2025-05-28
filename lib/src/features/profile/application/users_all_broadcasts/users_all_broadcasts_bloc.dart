import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/broadcast_exception.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'users_all_broadcasts_event.dart';
part 'users_all_broadcasts_state.dart';

const _size = 6;

class UsersAllBroadcastsBloc
    extends Bloc<UsersAllBroadcastsEvent, UsersAllBroadcastsState> {
  UsersAllBroadcastsBloc({
    required IBroadcastFacade facade,
    required ID? userId,
  })  : _facade = facade,
        _userId = userId,
        super(const UsersAllBroadcastsLoadInProgress()) {
    on<UsersAllBroadcastsFetchRequested>(_onUsersAllBroadcastsFetchRequested);
    on<UsersAllBroadcastsFetchMoreRequested>(
      _onUsersAllBroadcastsFetchMoreRequested,
    );
  }

  final IBroadcastFacade _facade;
  final ID? _userId;

  Future<void> _onUsersAllBroadcastsFetchRequested(
    UsersAllBroadcastsFetchRequested event,
    Emitter<UsersAllBroadcastsState> emit,
  ) async {
    if (_userId == null) {
      const exception = BroadcastExceptionWithMessage('No user provided.');
      emit(const UsersAllBroadcastsLoadFailure(exception));
    }

    emit(const UsersAllBroadcastsLoadInProgress());

    final result = await _facade.getBroadcasts(
      creatorId: _userId,
      size: _size,
      sortBy: 'endTime',
      orderBy: OrderBy.DESC,
    );

    return emit(
      result.fold(
        UsersAllBroadcastsLoadFailure.new,
        (success) => success.items.isEmpty
            ? const UsersAllBroadcastsEmpty()
            : UsersAllBroadcastsLoadSuccess(
                broadcasts: success.items,
                currentPage: success.currentPage,
              ),
      ),
    );
  }

  Future<void> _onUsersAllBroadcastsFetchMoreRequested(
    UsersAllBroadcastsFetchMoreRequested event,
    Emitter<UsersAllBroadcastsState> emit,
  ) async {
    if (state is UsersAllBroadcastsLoadSuccess) {
      final loadedState = state as UsersAllBroadcastsLoadSuccess;

      emit(UsersAllBroadcastsLoadMoreInProgress(loadedState.broadcasts));

      final result = await _facade.getBroadcasts(
        creatorId: _userId,
        size: _size,
        sortBy: 'endTime',
        orderBy: OrderBy.DESC,
        page: loadedState.currentPage + 1,
      );

      return emit(
        result.fold(
          UsersAllBroadcastsLoadFailure.new,
          (success) {
            if (success.currentPage < success.totalPages) {
              return UsersAllBroadcastsLoadSuccess(
                broadcasts: [...loadedState.broadcasts, ...success.items],
                currentPage: success.currentPage,
              );
            } else {
              return UsersAllBroadcastsLoadLastSuccess(loadedState.broadcasts);
            }
          },
        ),
      );
    }
  }
}
