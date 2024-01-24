import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'recently_live_list_bloc.freezed.dart';
part 'recently_live_list_event.dart';
part 'recently_live_list_state.dart';

const size = 6;

@injectable
class RecentlyLiveListBloc
    extends Bloc<RecentlyLiveListEvent, RecentlyLiveListState> {
  final IBroadcastFacade _facade;

  RecentlyLiveListBloc({
    required IBroadcastFacade facade,
  })  : _facade = facade,
        super(const RecentlyLiveListState.loading()) {
    on<_RLLFetchBroadcasts>(_onFetch);
    on<_RLLFetchMoreBroadcasts>(_onFetchMore);
  }

  @PostConstruct(preResolve: true)
  Future<void> fetch() async => add(const _RLLFetchBroadcasts());

  Future<void> _onFetch(
    _RLLFetchBroadcasts event,
    Emitter<RecentlyLiveListState> emit,
  ) async {
    emit(const RecentlyLiveListState.loading());

    final result = await _facade.getBroadcasts(
      size: size,
      orderBy: 'DESC',
      sortBy: 'startTime',
      page: 1,
    );

    return result.fold(
      (failure) => emit(const RecentlyLiveListState.failure()),
      (broadcasts) => broadcasts.isEmpty
          ? emit(const RecentlyLiveListState.empty())
          : emit(RecentlyLiveListState.success(broadcasts)),
    );
  }

  Future<void> _onFetchMore(
    _RLLFetchMoreBroadcasts event,
    Emitter<RecentlyLiveListState> emit,
  ) async {
    if (state is _RLLLoadSuccess) {
      final loadedState = (state as _RLLLoadSuccess);

      emit(RecentlyLiveListState.loadingMore(loadedState.broadcasts));

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
            ? emit(RecentlyLiveListState.successLast(loadedState.broadcasts))
            : emit(RecentlyLiveListState.success([
                ...loadedState.broadcasts,
                ...broadcasts,
              ])),
      );
    }
  }
}
