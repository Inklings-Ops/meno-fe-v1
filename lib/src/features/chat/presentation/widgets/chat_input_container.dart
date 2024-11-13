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
    final textTheme = MTextTheme.of(context)!;

    final socketBloc = context.read<SocketBloc>();

    final contentController = useTextEditingController();
    final reactionVisible = useState<bool>(false);
    final isSendVisible = useState(contentController.text.isNotEmpty);

    useEffect(
      () {
        contentController.addListener(() {
          isSendVisible.value = contentController.text.isNotEmpty;
        });
        return null;
      },
      [contentController.text],
    );

    final currentUserId = context.select(
      (SessionCubit bloc) => bloc.state.maybeWhen(
        orElse: () => '',
        authenticated: (user, token) => user.id.getOr(),
      ),
    );

    void sendMessage() {
      socketBloc.add(
        SocketSendMessage(
          senderId: currentUserId,
          broadcastId: broadcast.id.getOr(),
          content: contentController.text,
          createdAt: DateTime.timestamp().toIso8601String(),
        ),
      );

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      contentController.clear();
    }

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        if (reactionVisible.value) const ReactionButton(),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    style: textTheme.captionRegular,
                    controller: contentController,
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
                onPressed: () => reactionVisible.value = !reactionVisible.value,
              ),
              if (isSendVisible.value) ...[
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
            ],
          ),
        ),
      ],
    );
  }
}
