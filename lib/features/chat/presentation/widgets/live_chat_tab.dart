import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/presentation/presentation.dart';

class LiveChatTab extends WatchingStatefulWidget {
  const LiveChatTab({super.key});

  @override
  State<LiveChatTab> createState() => _LiveChatTabState();
}

class _LiveChatTabState extends State<LiveChatTab> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final welcomeMessageVisible = watchValue(
      (ChatManager m) => m.welcomeMessageVisible,
    );

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
                if (welcomeMessageVisible)
                  const ChatWelcomeWidget()
                else
                  const SizedBox(),
                // const EditingMessageWidget(),
                ChatInputContainer(scrollController: scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
