// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:rxdart/rxdart.dart';

part 'accounts_search_event.dart';
part 'accounts_search_state.dart';

class AccountsSearchBloc
    extends Bloc<AccountsSearchEvent, AccountsSearchState> {
  AccountsSearchBloc({required IProfileFacade facade})
      : _facade = facade,
        super(const AccountsSearchState()) {
    on<AccountSearchResultsFetched>(_onAccountSearchResultsFetched);
    on<AccountSearchKeywordChanged>(
      _onAccountSearchKeywordChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }

  final IProfileFacade _facade;

  Future<void> _onAccountSearchResultsFetched(
    AccountSearchResultsFetched event,
    Emitter<AccountsSearchState> emit,
  ) async {
    if (state.hasMore || !state.isSearchingMore) {
      emit(state.copyWith(isSearchingMore: true));
      final fOrS = await _facade.getProfiles(
        keywords: state.keyword,
        page: event.currentPage,
        size: 8,
      );
      emit(
        fOrS.fold(
          (f) => state.copyWith(isLoading: false, exception: f),
          (r) => state.copyWith(
            isLoading: false,
            profiles: [...state.profiles, ...r.items],
            page: event.currentPage,
            hasMore: event.currentPage < r.totalPages,
          ),
        ),
      );
    }
  }

  Future<void> _onAccountSearchKeywordChanged(
    AccountSearchKeywordChanged event,
    Emitter<AccountsSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        keyword: event.keyword,
        isLoading: true,
        hasMore: true,
        exception: null,
      ),
    );
    final fOrS = await _facade.getProfiles(keywords: event.keyword, size: 8);
    emit(
      fOrS.fold(
        (f) => state.copyWith(isLoading: false, exception: f),
        (r) => state.copyWith(
          isLoading: false,
          profiles: r.items,
          hasMore: r.currentPage < r.totalPages,
        ),
      ),
    );
  }
}
