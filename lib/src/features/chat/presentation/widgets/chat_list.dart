import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class ChatList extends StatelessWidget {
  const ChatList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      buildWhen: (previous, current) => previous.chats != current.chats,
      builder: (context, state) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        controller: scrollController,
        reverse: true,
        shrinkWrap: true,
        separatorBuilder: (context, _) => Spaces.verticalLarge,
        itemCount: state.chats.length,
        itemBuilder: (context, i) => _ChatBubble(chat: state.chats[i]!),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final broadcast = context.read<ChatListBloc>().state.broadcast;
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          final currentUserId = user.id.getOr();
          final senderId = chat.senderId;
          return GestureDetector(
            onLongPress: () {
              final isHost = user.id.getOr() == broadcast.creator!.id;
              if (currentUserId == senderId) {
                showMyChatOptions(context, chat: chat);
              } else {
                showOtherChatOptions(
                  context,
                  chat: chat,
                  isHost: isHost,
                );
              }
            },
            child: ChatBubble(chat: chat),
          );
        },
      ),
    );
  }

  bool isMessageEditable(Chat chat) {
    final now = DateTime.now();
    final difference = now.difference(chat.updatedAt ?? chat.createdAt);
    return difference.inMinutes < 15;
  }

  Future<void> handleDeleteMessage(BuildContext context, Chat chat) async {
    final result = await context.showDeleteCommentDialog();
    if ((result ?? false) && context.mounted) {
      final socket = context.read<SocketBloc>();
      return socket.add(
        SocketDeleteMessage(
          id: chat.id,
          senderId: chat.sender?.id ?? chat.senderId ?? '',
          broadcastId: chat.broadcastId,
          content: chat.content.getOr(),
          createdAt: chat.createdAt.toIso8601String(),
        ),
      );
    }
  }

  Future<dynamic> showMyChatOptions(
    BuildContext context, {
    required Chat chat,
  }) {
    final isEditable = isMessageEditable(chat);
    return context.showModal(
      isScrollControlled: true,
      BlocListener<SocketBloc, SocketState>(
        listener: (context, state) {
          state.whenOrNull(deletedMessage: (chat) => router.pop());
        },
        child: MModal(
          title: 'My Comment',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spaces.verticalSmall,
              if (isEditable) ...[
                MModalListTile(
                  leading: const Icon(MIcons.edit_05),
                  title: 'Edit',
                  onTap: () {
                    router.pop<void>();
                    context.read<ChatInputCubit>().startEditing(chat);
                  },
                ),
                Spaces.verticalLarge,
              ],
              MModalListTile(
                leading: const Icon(MIcons.trash),
                title: 'Delete',
                onTap: () async => handleDeleteMessage(context, chat),
                titleColor: MColorScheme.of(context).error,
              ),
              Spaces.verticalLarge,
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showOtherChatOptions(
    BuildContext context, {
    required Chat chat,
    bool isHost = false,
  }) async {
    final colors = MColorScheme.of(context);

    return context.showModal(
      isScrollControlled: true,
      MModal(
        title: "User's Comment",
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spaces.verticalSmall,
            if (isHost)
              MModalListTile(
                leading: Icon(MIcons.trash, color: colors.error),
                title: 'Delete',
                onTap: () async => handleDeleteMessage(context, chat),
                titleColor: colors.error,
              )
            else
              MModalListTile(
                leading: const Icon(Icons.flag),
                title: 'Report',
                onTap: () {},
              ),
            Spaces.verticalLarge,
          ],
        ),
      ),
    );
  }
}
