part of 'chat_input_cubit.dart';

class ChatInputState with EquatableMixin {
  const ChatInputState({
    this.initialChat,
    this.content,
    this.isEditing = false,
    this.hideWelcomeNote = false,
  });

  final Chat? initialChat;
  final String? content;
  final bool isEditing;
  final bool hideWelcomeNote;

  ChatInputState copyWith({
    Chat? initialChat,
    String? content,
    bool? isEditing,
    bool? hideWelcomeNote,
  }) {
    return ChatInputState(
      initialChat: initialChat ?? this.initialChat,
      content: content ?? this.content,
      isEditing: isEditing ?? this.isEditing,
      hideWelcomeNote: hideWelcomeNote ?? this.hideWelcomeNote,
    );
  }

  @override
  List<Object?> get props => [initialChat, content, isEditing, hideWelcomeNote];
}
