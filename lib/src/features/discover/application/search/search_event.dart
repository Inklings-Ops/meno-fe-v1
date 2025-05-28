part of 'search_bloc.dart';

sealed class SearchEvent with EquatableMixin {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class SearchRefreshRequested extends SearchEvent {
  const SearchRefreshRequested();
}

final class SearchKeywordChanged extends SearchEvent {
  const SearchKeywordChanged(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

final class SearchFetchResultsRequested extends SearchEvent {
  const SearchFetchResultsRequested(this.currentPage);
  final int currentPage;

  @override
  List<Object?> get props => [currentPage];
}
