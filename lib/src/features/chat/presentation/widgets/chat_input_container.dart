import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ChatInputContainer extends HookWidget {
  const ChatInputContainer({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _ChatTextField()),
              Spaces.horizontalLarge,
              HorizontalPopupMenu(
                icon: MIconButton(
                  size: 40,
                  iconSize: 20,
                  icon: const Icon(Icons.face),
                  isFilled: true,
                  fillColor: colors.outlineVariant2,
                ),
                items: mainReactions.map((reaction) {
                  return MIconButton(
                    size: 40,
                    iconSize: 20,
                    icon: reaction.icon,
                    isFilled: true,
                    fillColor: colors.outlineVariant2,
                    onPressed: () {},
                  );
                }).toList(),
              ),
              Spaces.horizontalSmall,
              ChatSendButton(scrollController: scrollController),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatTextField extends HookWidget {
  const _ChatTextField();

  @override
  Widget build(BuildContext context) {
    final inputBloc = context.watch<ChatInputCubit>();
    final focusNode = useFocusNode();
    final controller = useTextEditingController(text: inputBloc.state.content);

    useEffect(
      () {
        controller.text = inputBloc.state.content ?? '';
        return null;
      },
      [inputBloc.state.content],
    );

    return TextFormField(
      focusNode: focusNode,
      style: MTextTheme.of(context).captionRegular,
      controller: controller,
      onChanged: inputBloc.contentChanged,
      maxLines: 5,
      minLines: 1,
      maxLength: 244,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Type your comment here...',
        counter: SizedBox(),
        contentPadding: EdgeInsets.symmetric(
          vertical: Insets.sm,
          horizontal: Insets.md,
        ),
      ),
    );
  }
}
