part of 'search_bloc.dart';

final class SearchState with EquatableMixin {
  const SearchState({
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.keyword,
    this.searchResults = const [],
    this.isSearchingMore = false,
    this.exception,
  });

  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? keyword;
  final List<Broadcast?> searchResults;
  final bool isSearchingMore;
  final BroadcastException? exception;

  SearchState copyWith({
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? keyword,
    List<Broadcast?>? searchResults,
    bool? isSearchingMore,
    BroadcastException? exception,
  }) {
    return SearchState(
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
      searchResults: searchResults ?? this.searchResults,
      isSearchingMore: isSearchingMore ?? this.isSearchingMore,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        page,
        isLoading,
        hasMore,
        keyword,
        searchResults,
        isSearchingMore,
        exception,
      ];
}
