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

    final bloc = context.watch<ChatBloc>();

    final textEditingController = useTextEditingController();

    useEffect(
      () {
        void listener() {
          final newContent = textEditingController.text;
          if (bloc.state.content != newContent) {
            bloc.add(ContentChanged(newContent));
          }
        }

        textEditingController.addListener(listener);
        return () => textEditingController.removeListener(listener);
      },
      [textEditingController, bloc],
    );

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        if (bloc.state.showReactions) const ReactionButton(),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: textEditingController,
                    style: MTextTheme.of(context)!.captionRegular,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Insets.md,
                      ),
                      hintText: 'Type your comment here...',
                    ),
                  ),
                ),
              ),
              Spaces.horizontalLarge,
              MIconButton(
                size: 40,
                iconSize: 20,
                icon: const Icon(Icons.face),
                isFilled: true,
                fillColor: colors.outlineVariant2,
                onPressed: () => bloc.add(const ToggleShowReactions()),
              ),
              _SendButton(
                scrollController: scrollController,
                textEditingController: textEditingController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.scrollController,
    required this.textEditingController,
  });

  final ScrollController scrollController;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final broadcastId = context.select((ChatBloc b) => b.state.broadcast.id);

    final colors = MColorScheme.of(context)!;

    final currentUserId = context.read<SessionCubit>().state.maybeWhen(
          orElse: () => '',
          authenticated: (user, token) => user.id.getOr(),
        );

    final chat = context.watch<ChatBloc>();

    final isLive = [
      const Live(),
      const Streaming(),
      const Reconnecting(),
    ].contains(context.watch<LiveBloc>().state);

    void sendMessage() {
      final event = SocketSendMessage(
        senderId: currentUserId,
        broadcastId: broadcastId.getOr(),
        content: chat.state.content!,
        createdAt: DateTime.timestamp().toIso8601String(),
      );

      context.read<SocketBloc>().add(event);

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      textEditingController.clear();
    }

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.hasContent && isLive) {
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
