import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final broadcastBloc = context.watch<BroadcastBloc>();
    final chatInputBloc = context.watch<ChatInputCubit>();

    final inputState = chatInputBloc.state;
    final isEditing = inputState.isEditing && inputState.initialChat != null;

    void submit() {
      late ChatListEvent event;
      if (isEditing) {
        final chat = inputState.initialChat!;
        final contentString = inputState.content;
        if (contentString == null) return;
        final updatedContent = MultiLineString(contentString);
        final updatedChat = chat.copyWith(content: updatedContent);
        event = ChatEditMessageRequested(updatedChat);
        chatInputBloc.stopEditing();
      } else {
        event = ChatSendMessageRequested(
          broadcastId: broadcastBloc.state.broadcast.id,
          content: inputState.content!,
        );
        chatInputBloc.clearContent();
      }
      FocusScope.of(context).unfocus();
      context.read<ChatListBloc>().add(event);
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return BlocBuilder<ChatInputCubit, ChatInputState>(
      bloc: chatInputBloc,
      builder: (context, state) {
        final content = state.content;
        if (content != null) {
          return Column(
            children: [
              Spaces.horizontalSmall,
              MIconButton(
                icon: const Icon(MIcons.send),
                isFilled: true,
                fillColor: colors.primary,
                color: colors.onPrimary,
                size: 40,
                iconSize: 20,
                onPressed: submit,
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
