import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class ChatTab extends HookWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ChatList(scrollController: scrollController),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                BlocBuilder<ChatInputCubit, ChatInputState>(
                  buildWhen: (p, c) => p.hideWelcomeNote != c.hideWelcomeNote,
                  builder: (context, state) => !state.hideWelcomeNote
                      ? const ChatWelcomeWidget()
                      : const SizedBox(),
                ),
                const EditingMessageWidget(),
                SizedBox(
                  height: 52,
                  width: constraints.maxWidth,
                  child: ChatInputContainer(scrollController: scrollController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditingMessageWidget extends StatelessWidget {
  const EditingMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    return BlocConsumer<ChatInputCubit, ChatInputState>(
      listener: (context, state) {},
      builder: (context, state) {
        final initialChat = state.initialChat;
        if (state.isEditing && initialChat != null) {
          return Container(
            height: 100,
            width: double.infinity,
            color: colors.disabledContainer,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: Border(
                      left: BorderSide(
                        color: colors.secondary!,
                        width: 8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MText(
                            'You',
                            style: textTheme.bodyBold,
                            color: colors.informational,
                          ),
                          Spaces.verticalMicro,
                          MText(
                            initialChat.content.getOr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spaces.horizontalSmall,
                IconButton(
                  onPressed: context.read<ChatInputCubit>().stopEditing,
                  icon: const Icon(MIcons.x_close),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
