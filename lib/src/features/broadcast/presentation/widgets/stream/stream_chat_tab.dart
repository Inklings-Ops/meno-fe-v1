import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class StreamChatTab extends HookWidget {
  const StreamChatTab({super.key});

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
