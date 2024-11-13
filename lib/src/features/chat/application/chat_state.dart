part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatInitial;
  const factory ChatState.loadInProgress() = ChatLoadInProgress;
  const factory ChatState.success(List<Chat?> chats) = ChatLoadSuccess;
  const factory ChatState.failed(String error) = ChatLoadFailed;
}
