import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:rxdart/rxdart.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required IDiscoverFacade facade})
      : _facade = facade,
        super(SearchState.initial()) {
    on<SearchRefreshed>(_onSearchRefreshed);
    on<SearchResultsFetched>(_onSearchResultsFetched);
    on<SearchBarChanged>(
      _onSearchBarChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }
  final IDiscoverFacade _facade;

  Future<void> _onSearchResultsFetched(
    SearchResultsFetched event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasMore || !state.isSearchingMore) {
      emit(state.copyWith(isSearchingMore: true));
      final fOrS = await _facade.search(
        keywords: state.keyword,
        page: event.page,
        size: 6,
      );
      emit(
        fOrS.fold(
          (f) => state.copyWith(isLoading: false, exception: f),
          (r) => state.copyWith(
            isLoading: false,
            searchResults: [...state.searchResults, ...r.broadcasts],
            page: event.page,
            hasMore: event.page < r.totalPages,
          ),
        ),
      );
    }
  }

  Future<void> _onSearchBarChanged(
    SearchBarChanged event,
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
    final fOrS = await _facade.search(keywords: event.keyword, size: 6);
    emit(
      fOrS.fold(
        (f) => state.copyWith(isLoading: false, exception: f),
        (r) => state.copyWith(
          isLoading: false,
          searchResults: r.broadcasts,
          hasMore: r.currentPage < r.totalPages,
        ),
      ),
    );
  }

  Future<void> _onSearchRefreshed(SearchRefreshed event, emit) async {}
}
