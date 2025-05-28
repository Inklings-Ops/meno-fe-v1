part of 'accounts_search_bloc.dart';

sealed class AccountsSearchEvent with EquatableMixin {
  const AccountsSearchEvent();

  @override
  List<Object?> get props => [];
}

final class AccountSearchRefreshRequested extends AccountsSearchEvent {
  const AccountSearchRefreshRequested();
}

final class AccountSearchKeywordChanged extends AccountsSearchEvent {
  const AccountSearchKeywordChanged(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

final class AccountSearchResultsFetched extends AccountsSearchEvent {
  const AccountSearchResultsFetched(this.currentPage);
  final int currentPage;

  @override
  List<Object?> get props => [currentPage];
}
