part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.deleteMessage(String id) = _DeleteMessage;

  const factory ChatEvent.editMessage({
    required String content,
    required String broadcastId,
  }) = _EditMessage;

  const factory ChatEvent.getMessages(String broadcastId) = _GetMessages;

  const factory ChatEvent.getRecentMessages({
    required String broadcastId,
    int? page,
    int? size,
  }) = _GetRecentMessages;

  const factory ChatEvent.sendMessage({
    required String content,
    required String broadcastId,
  }) = _SendMessage;

  const factory ChatEvent.updateMessages(dynamic data) = _UpdateMessages;
}
