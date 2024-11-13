import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class StreamChatTab extends HookWidget {
  const StreamChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.read<StreamBloc>().state.broadcast;
    final scrollController = useScrollController();

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ChatList(
                broadcast: broadcast,
                scrollController: scrollController,
              ),
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: 52,
              width: constraints.maxWidth,
              child: ChatInputContainer(
                broadcast: broadcast,
                scrollController: scrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
