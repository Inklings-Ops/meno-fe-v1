 
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class BroadcastChatTab extends HookWidget {
  const BroadcastChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [MText('Waiting for broadcast to start')],
        ),
        startSuccess: (broadcast, muted) => LayoutBuilder(
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
