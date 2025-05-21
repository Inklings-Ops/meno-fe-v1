// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputState> {
  ChatInputCubit() : super(const ChatInputState());

  void contentChanged(String content) => emit(state.copyWith(content: content));

  void startEditing(Chat chat) {
    emit(
      state.copyWith(
        isEditing: true,
        initialChat: chat,
        content: chat.content.getOr(),
      ),
    );
  }

  void stopEditing() {
    emit(
      state.copyWith(
        isEditing: false,
        initialChat: null,
        content: null,
      ),
    );
  }

  void clearContent() => emit(state.copyWith(content: null));

  void hideWelcomeNote() => emit(state.copyWith(hideWelcomeNote: true));
}
