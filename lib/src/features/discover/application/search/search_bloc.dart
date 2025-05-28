// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/broadcast_exception.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(const SearchState()) {
    on<SearchRefreshRequested>(_onSearchRefreshRequested);
    on<SearchFetchResultsRequested>(_onSearchFetchResultsRequested);
    on<SearchKeywordChanged>(
      _onSearchKeywordChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }

  final IBroadcastFacade _facade;

  Future<void> _onSearchFetchResultsRequested(
    SearchFetchResultsRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasMore || !state.isSearchingMore) {
      emit(state.copyWith(isSearchingMore: true));
      final fOrS = await _facade.getBroadcasts(
        keywords: state.keyword,
        page: event.currentPage,
        size: 10,
        orderBy: OrderBy.ASC,
        sortBy: 'title',
      );
      emit(
        fOrS.fold(
          (f) => state.copyWith(isLoading: false, exception: f),
          (r) => state.copyWith(
            isLoading: false,
            searchResults: [...state.searchResults, ...r.items],
            page: event.currentPage,
            hasMore: event.currentPage < r.totalPages,
          ),
        ),
      );
    }
  }

  Future<void> _onSearchKeywordChanged(
    SearchKeywordChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        keyword: event.keyword,
        isLoading: true,
        hasMore: true,
        exception: null,
      ),
    );
    final fOrS = await _facade.getBroadcasts(
      keywords: state.keyword,
      size: 10,
      orderBy: OrderBy.ASC,
      sortBy: 'title',
    );
    emit(
      fOrS.fold(
        (f) => state.copyWith(isLoading: false, exception: f),
        (r) => state.copyWith(
          isLoading: false,
          searchResults: r.items,
          hasMore: r.currentPage < r.totalPages,
        ),
      ),
    );
  }

  Future<void> _onSearchRefreshRequested(
    SearchRefreshRequested event,
    emit,
  ) async {}
}
