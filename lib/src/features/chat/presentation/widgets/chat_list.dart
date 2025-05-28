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
    final senderId = chat.senderId ?? chat.sender?.id;

    final broadcastCreatorId = context.select<BroadcastBloc, ID?>(
      (bloc) {
        final broadcast = bloc.state.broadcast;
        return broadcast.creator?.id ?? broadcast.creatorId;
      },
    );

    final myUserId = context.select(
      (SessionBloc bloc) => switch (bloc.state) {
        SessionAuthenticated(:final user) => user.id,
        _ => null,
      },
    );

    // If the currently authenticated user is also the host of the broadcast
    final isHost = myUserId == broadcastCreatorId;

    // If the currently authenticated user is also the sender of this chat msg
    final isCurrentUserTheSender = myUserId == senderId;

    return GestureDetector(
      onLongPress: () {
        if (isCurrentUserTheSender) {
          showMyChatOptions(context, chat: chat);
        } else {
          showOtherChatOptions(context, chat: chat, isHost: isHost);
        }
      },
      child: ChatBubble(chat: chat),
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
      return context.read<ChatListBloc>().add(ChatDeleteRequested(chat));
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
          if (state is SocketDeletedChatReceived) router.pop();
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
