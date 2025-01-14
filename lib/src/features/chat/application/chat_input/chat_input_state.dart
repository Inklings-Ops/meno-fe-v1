part of 'chat_input_cubit.dart';

@freezed
class ChatInputState with _$ChatInputState {
  const factory ChatInputState({
    Chat? initialChat,
    String? content,
    @Default(false) bool isEditing,
    @Default(false) bool hideWelcomeNote,
  }) = _ChatInputState;
}
