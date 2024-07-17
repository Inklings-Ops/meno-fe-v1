import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

part 'filter_bloc.freezed.dart';
part 'filter_event.dart';
part 'filter_state.dart';

@lazySingleton
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final IDiscoverFacade _facade;
  FilterBloc({required IDiscoverFacade facade})
      : _facade = facade,
        super(FilterState.initial()) {
    on<FilterFetched>(_onFilterFetched);
    on<FilterRefreshed>(_onFilterRefreshed);
    on<FilterChanged>(_onFilterChanged);
  }

  void init() => add(const FilterFetched(1));

  Future<void> _onFilterFetched(FilterFetched event, emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, exception: null, hasMore: true));
    final fOrS = await _fetch(state.filter, event.page);
    emit(fOrS.fold(
      (f) => state.copyWith(isLoading: false, exception: f),
      (s) {
        final map = {...state.searchMap};
        final broadcasts = state.searchMap[state.filter] ?? [];
        final updatedSearchMap = {
          state.filter: [...broadcasts, ...s.broadcasts]
        };
        return state.copyWith(
          isLoading: false,
          filter: state.filter,
          searchMap: map..addAll(updatedSearchMap),
          page: s.currentPage,
          hasMore: event.page >= s.totalPages,
        );
      },
    ));
  }

  Future<void> _onFilterRefreshed(FilterRefreshed event, emit) async {
    final map = {...state.searchMap};
    emit(state.copyWith(isLoading: true, hasMore: true));
    final fOrS = await _fetch(state.filter, 1);
    emit(fOrS.fold(
      (f) => state.copyWith(isLoading: false, exception: f),
      (s) => state.copyWith(
        isLoading: false,
        searchMap: map..addAll({state.filter: s.broadcasts}),
        page: s.currentPage,
        hasMore: 1 >= s.totalPages,
      ),
    ));
  }

  Future<void> _onFilterChanged(FilterChanged event, emit) async {
    emit(state.copyWith(filter: event.filter));
    final hasEntry = state.searchMap.containsKey(event.filter);
    if (hasEntry) return emit(state);
    return add(const FilterRefreshed());
  }

  Future<Either<DiscoverException, DiscoverResult>> _fetch(
    Filter filter,
    int page,
  ) async {
    return await switch (filter) {
      Filter.recentlyLive => _facade.fetchRecentlyLive(page: page),
      Filter.nowLive => _facade.fetchNowLive(page: page),
      Filter.all => _facade.fetchBroadcasts(page: page),
    };
  }
}
