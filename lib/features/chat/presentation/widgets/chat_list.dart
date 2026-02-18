import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatList extends WatchingStatefulWidget {
  const ChatList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final ctrl = widget.scrollController;
    // In a reversed list, maxScrollExtent is the "top" (oldest messages)
    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      di<ChatListManager>().fetchOlderMessages.run();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = watchValue((ChatListManager m) => m.messages);
    final isFetchingOld = watchValue((ChatListManager m) => m.isFetchingOlder);
    final hasReachedEnd = watchValue((ChatListManager m) => m.hasReachedEnd);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      controller: widget.scrollController,
      reverse: true,
      separatorBuilder: (context, _) => Spaces.verticalLarge,
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == messages.length) {
          if (hasReachedEnd) return const _BeginningOfChatIndicator();
          if (isFetchingOld) return const _LoadingIndicator();
          return const SizedBox.shrink();
        }

        return ChatBubble(message: messages[index]);
      },
    );
  }
}

class _BeginningOfChatIndicator extends StatelessWidget {
  const _BeginningOfChatIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: MText(
          'Beginning of chat',
          style: textTheme.captionRegular,
          color: colors.inActive.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: MLoadingIndicator.box()),
    );
  }
}
