// ignore_for_file: prefer_const_constructors

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class ChatList extends StatelessWidget {
  const ChatList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatListBloc>();

    return BlocListener<SocketBloc, SocketState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        state.whenOrNull(
          newMessage: (chat) => bloc.add(NewChatReceived(chat)),
          editedMessage: (chat) => bloc.add(EditedChatReceived(chat)),
          deletedMessage: (chat) => bloc.add(DeletedChatRemoved(chat)),
        );
      },
      child: BlocBuilder<ChatListBloc, ChatListState>(
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
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          final currentUserId = user.id.getOr();
          final senderId = chat.senderId;
          return GestureDetector(
            onLongPress: () {
              final isHost = user.id.getOr() == broadcast.creator!.id;
              if (currentUserId == senderId) {
                showMyChatOptions(context);
              } else {
                showOtherChatOptions(
                  chat: chat,
                  context: context,
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

  Future<dynamic> showMyChatOptions(BuildContext context) {
    return context.showModal(
      isScrollControlled: true,
      MModal(
        title: 'My Comment',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spaces.verticalSmall,
            MModalListTile(
              leading: const Icon(MIcons.edit_05),
              title: 'Edit',
              onTap: () {
                router.pop<void>();
                context.read<ChatInputCubit>().startEditing(chat);
              },
            ),
            Spaces.verticalLarge,
            MModalListTile(
              leading: const Icon(MIcons.trash),
              title: 'Delete',
              onTap: () => context.showDeleteCommentDialog(),
              titleColor: MColorScheme.of(context)!.error,
            ),
            Spaces.verticalLarge,
          ],
        ),
      ),
    );
  }

  Future<dynamic> showOtherChatOptions({
    required BuildContext context,
    required Chat chat,
    bool isHost = false,
  }) async {
    final colors = MColorScheme.of(context)!;

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
                onTap: () {
                  final socket = context.read<SocketBloc>();
                  socket.add(
                    SocketDeleteMessage(
                      id: chat.id,
                      senderId: chat.sender?.id ?? chat.senderId ?? '',
                      broadcastId: chat.broadcastId,
                      content: chat.content.getOr(),
                      createdAt: chat.createdAt.toIso8601String(),
                    ),
                  );
                },
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
