import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class ChatInputContainer extends HookWidget {
  const ChatInputContainer({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<ChatBloc>();
    final contentController = useTextEditingController();
    final isReactionsVisible = useState<bool>(false);
    final isSendVisible = useState(contentController.text.isNotEmpty);
    useEffect(() {
      contentController.addListener(() {
        isSendVisible.value = contentController.text.isNotEmpty;
      });
      return null;
    }, [contentController.text]);

    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (p, c) => p.onSend != c.onSend,
      listener: (context, state) {
        state.onSend.fold(() => null, (a) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          if (isReactionsVisible.value) const ReactionButton(),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8).radius,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40.toScale,
                    child: TextFormField(
                      style: $styles.text.captionRegular,
                      controller: contentController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: $styles.insets.medium,
                        ),
                        hintText: 'Type your comment here...',
                      ),
                    ),
                  ),
                ),
                $styles.spaces.horizontalLarge,
                MIconButton(
                  size: 40.toScale,
                  iconSize: 20.toScale,
                  icon: const Icon(Icons.face),
                  isFilled: true,
                  fillColor: colors.outlineVariant2,
                  onPressed: () =>
                      isReactionsVisible.value = !isReactionsVisible.value,
                ),
                if (isSendVisible.value) ...[
                  $styles.spaces.horizontalSmall,
                  BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, state) => state.maybeWhen(
                      orElse: () => const SizedBox(),
                      authenticated: (user, _) => MIconButton(
                        icon: const Icon(MIcons.send),
                        isFilled: true,
                        fillColor: colors.primary,
                        color: colors.onPrimary,
                        size: 40.toScale,
                        iconSize: 20.toScale,
                        onPressed: () {
                          bloc.sendMessage(contentController.text);
                          scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          contentController.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReactionButton extends StatelessWidget {
  const ReactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Positioned(
      bottom: 60.toScale,
      right: 16.toScale,
      child: Container(
        height: 56.toScale,
        padding: EdgeInsets.all($styles.insets.small),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: $styles.radius.circle,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, i) => $styles.spaces.horizontalSmall,
          scrollDirection: Axis.horizontal,
          itemCount: reactions.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredList(
              position: i,
              duration: const Duration(milliseconds: 260),
              child: SlideAnimation(
                verticalOffset: (15 + i * 15).toScale,
                child: FadeInAnimation(
                  child: MIconButton(
                    size: 40.toScale,
                    iconSize: 20.toScale,
                    icon: reactions[i].icon,
                    isFilled: true,
                    fillColor: colors.outlineVariant2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
