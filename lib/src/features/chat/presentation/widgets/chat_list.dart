// ignore_for_file: prefer_const_constructors

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    required this.broadcast,
    required this.scrollController,
    super.key,
  });

  final Broadcast broadcast;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();
    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        state.whenOrNull(
          newMessage: (chat) => bloc.add(NewChatReceived(chat)),
          messagesReceived: (chats) => bloc.add(LoadChatMessages(chats)),
        );
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) => state.when(
          initial: () => const SizedBox(),
          loadInProgress: () => Center(child: MLoadingIndicator.box()),
          success: (chats) => ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
            controller: scrollController,
            reverse: true,
            shrinkWrap: true,
            separatorBuilder: (context, _) => Spaces.verticalLarge,
            itemCount: chats.length,
            itemBuilder: (context, i) => _ChatBubble(
              broadcast: broadcast,
              chat: chats[i]!,
            ),
          ),
          failed: (error) => Center(
            child: Column(
              children: [
                Text(error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.broadcast, required this.chat});

  final Broadcast broadcast;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) => GestureDetector(
          onLongPress: () {
            final isSender = user.id.getOr() == chat.senderId;
            final isHost = user.id.getOr() == broadcast.creator!.id;
            if (isSender) {
              showOtherChatOptions(context);
            } else {
              showOtherChatOptions(context, isHost: isHost);
            }
          },
          child: ChatBubble(chat: chat),
        ),
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
              onTap: () {},
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

  Future<dynamic> showOtherChatOptions(
    BuildContext context, {
    bool isHost = false,
  }) async {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<ChatBloc>();
    return context.showModal(
      isScrollControlled: true,
      MModal(
        title: "User's Comment",
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spaces.verticalSmall,
            if (isHost)
              MModalListTile(
                leading: Icon(MIcons.trash, color: colors.error),
                title: 'Delete',
                onTap: () => bloc.add(ChatDeletePressed(chat)),
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
