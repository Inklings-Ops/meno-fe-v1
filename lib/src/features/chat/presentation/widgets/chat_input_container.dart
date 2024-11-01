import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class ChatInputContainer extends HookWidget {
  const ChatInputContainer({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final bloc = context.read<ChatBloc>();
    final contentController = useTextEditingController();
    final isReactionsVisible = useState<bool>(false);
    final isSendVisible = useState(contentController.text.isNotEmpty);
    
    useEffect(() {
      contentController.addListener(() {
        isSendVisible.value = contentController.text.isNotEmpty;
      });
      return null;
    }, [contentController.text],);

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        if (isReactionsVisible.value) const ReactionButton(),
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
                onPressed: () =>
                    isReactionsVisible.value = !isReactionsVisible.value,
              ),
              if (isSendVisible.value) ...[
                Spaces.horizontalSmall,
                BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => const SizedBox(),
                    authenticated: (user, _) => MIconButton(
                      icon: const Icon(MIcons.send),
                      isFilled: true,
                      fillColor: colors.primary,
                      color: colors.onPrimary,
                      size: 40,
                      iconSize: 20,
                      onPressed: () {
                        bloc.add(ChatSendPressed(contentController.text));
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
    );
  }
}

class ReactionButton extends StatelessWidget {
  const ReactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Positioned(
      bottom: 60,
      right: 16,
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(Insets.sm),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: Corners.circle,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, i) => Spaces.horizontalSmall,
          scrollDirection: Axis.horizontal,
          itemCount: reactions.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredList(
              position: i,
              duration: const Duration(milliseconds: 260),
              child: SlideAnimation(
                verticalOffset: 15 + i * 15,
                child: FadeInAnimation(
                  child: MIconButton(
                    size: 40,
                    iconSize: 20,
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
