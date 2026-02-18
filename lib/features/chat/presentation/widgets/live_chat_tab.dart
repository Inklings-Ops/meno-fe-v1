import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
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
                const ChatWelcomeWidget(),
                const EditingMessageWidget(),
                ChatInputContainer(scrollController: scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
