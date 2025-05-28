part of 'accounts_search_bloc.dart';

final class AccountsSearchState with EquatableMixin {
  const AccountsSearchState({
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.profiles = const [],
    this.isSearchingMore = false,
    this.keyword,
    this.exception,
  });

  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? keyword;
  final List<Profile?> profiles;
  final bool isSearchingMore;
  final ProfileException? exception;
  
  AccountsSearchState copyWith({
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? keyword,
    List<Profile?>? profiles,
    bool? isSearchingMore,
    ProfileException? exception,
  }) {
    return AccountsSearchState(
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
      profiles: profiles ?? this.profiles,
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
        profiles,
        isSearchingMore,
        exception,
      ];
}
