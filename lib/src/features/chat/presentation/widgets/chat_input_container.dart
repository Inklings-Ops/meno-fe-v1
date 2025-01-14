import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/presentation/widgets/reaction_button.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class ChatInputContainer extends HookWidget {
  const ChatInputContainer({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final chatListBloc = context.watch<ChatListBloc>();

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        if (chatListBloc.state.showReactions) const ReactionButton(),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              const Expanded(child: _ChatTextField()),
              Spaces.horizontalLarge,
              MIconButton(
                size: 40,
                iconSize: 20,
                icon: const Icon(Icons.face),
                isFilled: true,
                fillColor: colors.outlineVariant2,
                onPressed: () => chatListBloc.add(const ToggleShowReactions()),
              ),
              Spaces.horizontalSmall,
              _SendButton(scrollController: scrollController),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatTextField extends HookWidget {
  const _ChatTextField();

  @override
  Widget build(BuildContext context) {
    final inputBloc = context.watch<ChatInputCubit>();
    final controller = useTextEditingController(text: inputBloc.state.content);

    useEffect(
      () {
        controller.text = inputBloc.state.content ?? '';
        return null;
      },
      [inputBloc.state.content],
    );

    return SizedBox(
      height: 40,
      child: TextFormField(
        style: MTextTheme.of(context)!.captionRegular,
        controller: controller,
        onChanged: inputBloc.contentChanged,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: Insets.md),
          hintText: 'Type your comment here...',
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final chatInputBloc = context.watch<ChatInputCubit>();
    final chatListBloc = context.watch<ChatListBloc>();

    final currentUserId = context.read<SessionCubit>().state.maybeWhen(
          orElse: () => '',
          authenticated: (user, token) => user.id.getOr(),
        );

    final isLive = [
      const Live(),
      const Streaming(),
      const Reconnecting(),
    ].contains(context.watch<LiveBloc>().state);

    void sendMessage() {
      final event = SocketSendMessage(
        senderId: currentUserId,
        broadcastId: chatListBloc.state.broadcast.id.getOr(),
        content: chatInputBloc.state.content!,
        createdAt: DateTime.timestamp().toIso8601String(),
      );

      context.read<SocketBloc>().add(event);

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      chatInputBloc.clearContent();
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
                onPressed: sendMessage,
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
