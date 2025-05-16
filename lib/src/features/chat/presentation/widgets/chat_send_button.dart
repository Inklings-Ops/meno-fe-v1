import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final chatInputBloc = context.watch<ChatInputCubit>();
    final chatListBloc = context.watch<ChatListBloc>();

    final currentUserId = context.read<SessionBloc>().state.maybeWhen(
          orElse: () => '',
          authenticated: (user, token) => user.id.getOr(),
        );

    final isLive = [
      const Live(),
      const Streaming(),
      const Reconnecting(),
    ].contains(context.watch<LiveBloc>().state);

    final inputState = chatInputBloc.state;
    final isEditing = inputState.isEditing && inputState.initialChat != null;

    void submit() {
      late SocketEvent event;
      if (isEditing) {
        final chat = inputState.initialChat!;
        event = SocketEditMessage(
          id: chat.id,
          senderId: chat.sender?.id ?? chat.senderId ?? currentUserId,
          broadcastId: chat.broadcastId,
          content: chatInputBloc.state.content!,
          createdAt: chat.createdAt.toIso8601String(),
          updatedAt: DateTime.timestamp().toIso8601String(),
        );
      } else {
        event = SocketSendMessage(
          senderId: currentUserId,
          broadcastId: chatListBloc.state.broadcast.id.getOr(),
          content: chatInputBloc.state.content!,
          createdAt: DateTime.timestamp().toIso8601String(),
        );
      }

      context.read<SocketBloc>().add(event);

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      chatInputBloc.clearContent();
      chatInputBloc.stopEditing();
    }

    return BlocBuilder<ChatInputCubit, ChatInputState>(
      bloc: chatInputBloc,
      builder: (context, state) {
        final content = state.content;
        if (content != null && isLive) {
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
