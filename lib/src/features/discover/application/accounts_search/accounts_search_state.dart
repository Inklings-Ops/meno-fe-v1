part of 'accounts_search_bloc.dart';

@freezed
class AccountsSearchState with _$AccountsSearchState {
  const factory AccountsSearchState({
    required int page,
    required bool isLoading,
    required bool hasMore,
    required String? keyword,
    required List<Profile?> profiles,
    required bool isSearchingMore,
    AuthException? exception,
  }) = _AccountsSearchState;

  factory AccountsSearchState.initial() {
    return const AccountsSearchState(
      page: 1,
      isLoading: false,
      hasMore: true,
      keyword: null,
      profiles: [],
      isSearchingMore: false,
    );
  }}
