part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.refresh() = SearchRefreshed;
  const factory SearchEvent.searchBarChanged(String keyword) = SearchBarChanged;
  const factory SearchEvent.fetchSearchResults(int page) = SearchResultsFetched;
}
