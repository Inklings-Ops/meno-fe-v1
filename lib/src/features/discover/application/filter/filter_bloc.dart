// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(const FilterState()) {
    on<FilterFetchRequested>(_onFilterFetchRequested);
    on<FilterRefreshRequested>(_onFilterRefreshRequested);
    on<FilterChanged>(_onFilterChanged);
  }
  final IBroadcastFacade _facade;

  void init() => add(const FilterFetchRequested(1));

  Future<void> _onFilterFetchRequested(
    FilterFetchRequested event,
    Emitter<FilterState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, exception: null, hasMore: true));
    final fOrS = await _fetch(state.filter, event.currentPage);
    emit(
      fOrS.fold(
        (f) => state.copyWith(isLoading: false, exception: f),
        (s) {
          final map = {...state.searchMap};
          final broadcasts = state.searchMap[state.filter] ?? [];
          final updatedSearchMap = {
            state.filter: [...broadcasts, ...s.items],
          };
          return state.copyWith(
            isLoading: false,
            filter: state.filter,
            searchMap: map..addAll(updatedSearchMap),
            page: s.currentPage,
            hasMore: event.currentPage >= s.totalPages,
          );
        },
      ),
    );
  }

  Future<void> _onFilterRefreshRequested(
    FilterRefreshRequested event,
    Emitter<FilterState> emit,
  ) async {
    final map = {...state.searchMap};
    emit(state.copyWith(isLoading: true, hasMore: true));
    final fOrS = await _fetch(state.filter, 1);
    emit(
      fOrS.fold(
        (f) => state.copyWith(isLoading: false, exception: f),
        (s) => state.copyWith(
          isLoading: false,
          searchMap: map..addAll({state.filter: s.items}),
          page: s.currentPage,
          hasMore: 1 >= s.totalPages,
        ),
      ),
    );
  }

  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter));
    final hasEntry = state.searchMap.containsKey(event.filter);
    if (hasEntry) return emit(state);
    return add(const FilterRefreshRequested());
  }

  Future<Either<BroadcastException, PaginatedList<Broadcast?>>> _fetch(
    Filter filter,
    int page,
  ) async {
    return switch (filter) {
      Filter.recentlyLive => _facade.getBroadcasts(
          page: page,
          sortBy: 'endTime',
          orderBy: OrderBy.DESC,
          endTimeExist: true,
          include: 'totalListeners',
        ),
      Filter.nowLive => _facade.getBroadcasts(
          page: page,
          sortBy: 'startTime',
          orderBy: OrderBy.DESC,
          endTimeExist: false,
          startTimeExist: true,
          include: 'totalListeners',
          status: 'active',
        ),
      _ => _facade.getBroadcasts(
          page: page,
          sortBy: 'title',
          orderBy: OrderBy.ASC,
        ),
    };
  }
}
