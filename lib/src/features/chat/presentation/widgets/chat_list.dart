import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class ChatList extends StatelessWidget {
  const ChatList({required this.controller, super.key});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (p, c) => p.chats != c.chats,
      builder: (context, state) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        controller: controller,
        reverse: true,
        shrinkWrap: true,
        separatorBuilder: (context, _) => Spaces.verticalLarge,
        itemCount: state.chats.length,
        itemBuilder: (context, i) => _Item(chat: state.chats[i]!),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((ChatBloc bloc) => bloc.state.broadcast);
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
