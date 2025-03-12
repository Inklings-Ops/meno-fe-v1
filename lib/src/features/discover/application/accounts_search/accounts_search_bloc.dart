import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:rxdart/rxdart.dart';

part 'accounts_search_event.dart';
part 'accounts_search_state.dart';
part 'accounts_search_bloc.freezed.dart';

class AccountsSearchBloc
    extends Bloc<AccountsSearchEvent, AccountsSearchState> {
  AccountsSearchBloc({required IAuthFacade facade})
      : _facade = facade,
        super(AccountsSearchState.initial()) {
    on<AccountsSearchResultsFetched>(_onSearchResultsFetched);
    on<AccountsSearchBarChanged>(
      _onSearchBarChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }

  final IAuthFacade _facade;

  Future<void> _onSearchResultsFetched(
    AccountsSearchResultsFetched event,
    Emitter<AccountsSearchState> emit,
  ) async {
    if (state.hasMore || !state.isSearchingMore) {
      emit(state.copyWith(isSearchingMore: true));
      final fOrS = await _facade.getProfiles(
        keywords: state.keyword,
        page: event.page,
        size: 8,
      );
      emit(
        fOrS.fold(
          (f) => state.copyWith(isLoading: false, exception: f),
          (r) => state.copyWith(
            isLoading: false,
            profiles: [...state.profiles, ...r.profiles],
            page: event.page,
            hasMore: event.page < r.totalPages,
          ),
        ),
      );
    }
  }

  Future<void> _onSearchBarChanged(
    AccountsSearchBarChanged event,
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
          profiles: r.profiles,
          hasMore: r.currentPage < r.totalPages,
        ),
      ),
    );
  }
}
