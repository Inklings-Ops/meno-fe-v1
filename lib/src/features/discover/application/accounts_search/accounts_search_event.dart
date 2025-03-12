part of 'accounts_search_bloc.dart';

@freezed
class AccountsSearchEvent with _$AccountsSearchEvent {
  const factory AccountsSearchEvent.refresh() = AccountsSearchRefreshed;
  const factory AccountsSearchEvent.searchBarChanged(String keyword) = AccountsSearchBarChanged;
  const factory AccountsSearchEvent.fetchSearchResults(int page) = AccountsSearchResultsFetched;
}
