import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/presentation/widgets/reaction_button.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class ChatInputContainer extends HookWidget {
  const ChatInputContainer({
    required this.broadcast,
    required this.scrollController,
    super.key,
  });

  final Broadcast broadcast;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final bloc = context.watch<ChatBloc>();

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
              const Expanded(child: _InputField()),
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
                broadcastId: broadcast.id,
                scrollController: scrollController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        style: MTextTheme.of(context)!.captionRegular,
        onChanged: (v) => context.read<ChatBloc>().add(ContentChanged(v)),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: Insets.md),
          hintText: 'Type your comment here...',
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.broadcastId,
    required this.scrollController,
  });

  final Uid<Broadcast> broadcastId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
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

      chat.add(const ClearChatContent());
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
