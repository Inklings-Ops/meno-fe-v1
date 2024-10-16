import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class StreamChatTab extends HookWidget {
  const StreamChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) => state.status.maybeWhen(
        orElse: () => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [MText('Waiting to join stream')],
        ),
        joined: () => LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatList(controller: scrollController),
                ),
              ),
              SizedBox(
                height: 52,
                width: constraints.maxWidth,
                child: ChatInputContainer(scrollController: scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
