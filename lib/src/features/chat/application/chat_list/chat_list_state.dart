part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, success, failure }

final class ChatListState with EquatableMixin {
  const ChatListState({
    this.chats = const <Chat?>[],
    this.currentPage = 1,
    this.moreInProgress = false,
    this.hasMore = true,
    this.totalPages,
    this.exception,
    this.status = ChatListStatus.loading,
  });

  final List<Chat?> chats;
  final int currentPage;
  final int? totalPages;
  final bool moreInProgress;
  final bool hasMore;
  final ChatException? exception;
  final ChatListStatus status;

  ChatListState copyWith({
    List<Chat?>? chats,
    int? currentPage,
    int? totalPages,
    bool? moreInProgress,
    bool? hasMore,
    ChatException? exception,
    ChatListStatus? status,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      moreInProgress: moreInProgress ?? this.moreInProgress,
      hasMore: hasMore ?? this.hasMore,
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        chats,
        currentPage,
        totalPages,
        moreInProgress,
        hasMore,
        exception,
        status,
      ];
}
