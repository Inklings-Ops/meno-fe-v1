import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'recently_live_cubit.freezed.dart';
part 'recently_live_event.dart';
part 'recently_live_state.dart';

const size = 6;

@lazySingleton
class RecentlyLiveCubit extends Cubit<RecentlyLiveState> {
  final IBroadcastFacade _facade;

  RecentlyLiveCubit({
    required IBroadcastFacade facade,
  })  : _facade = facade,
        super(const RecentlyLiveState.loading());

  Future<void> fetch() async {
    emit(const RecentlyLiveState.loading());

    final result = await _facade.getBroadcasts(
      size: size,
      orderBy: 'DESC',
      sortBy: 'startTime',
      page: 1,
    );

    return result.fold(
      (failure) => emit(const RecentlyLiveState.failure()),
      (broadcasts) => broadcasts.isEmpty
          ? emit(const RecentlyLiveState.empty())
          : emit(RecentlyLiveState.success(broadcasts)),
    );
  }

  Future<void> fetchMore() async {
    if (state is _RLLLoadSuccess) {
      final loadedState = (state as _RLLLoadSuccess);

      emit(RecentlyLiveState.loadingMore(loadedState.broadcasts));

      final result = await _facade.getBroadcasts(
        size: size,
        orderBy: 'DESC',
        sortBy: 'startTime',
        // Calculates next page
        page: loadedState.broadcasts.length ~/ size + 1,
      );

      return result.fold(
        (failure) => emit(state),
        (broadcasts) => broadcasts.isEmpty
            ? emit(RecentlyLiveState.successLast(loadedState.broadcasts))
            : emit(RecentlyLiveState.success([
                ...loadedState.broadcasts,
                ...broadcasts,
              ])),
      );
    }
  }
}
