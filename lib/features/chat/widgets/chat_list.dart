import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/chat/manager/_manager.dart';
import 'package:meno/features/chat/widgets/chat_bubble.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatList extends WatchingWidget {
  const ChatList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final feed = di<ChatListManager>().feed;

    final itemCount = watch(feed.itemCount).value;
    final isFetching = watch(feed.isFetching).value;

    callOnce((_) => feed.updateDataCommand.run());

    registerHandler(
      target: feed.commandErrors,
      handler: (context, CommandError? error, _) {
        if (error?.error == null) return;
        context.showErrorSnackBar(error?.error.toString() ?? 'Unknown error');
      },
    );

    registerHandler(
      select: (ChatManager m) => m.sendMessage,
      handler: (_, __, ___) => _scrollToBottom(),
    );

    registerHandler(
      select: (ChatManager m) => m.editMessage,
      handler: (_, __, ___) => _scrollToBottom(),
    );

    if (!feed.updateWasCalled && isFetching) return const _LoadingIndicator();

    if (feed.updateWasCalled && itemCount == 0) return const SizedBox.shrink();

    return ListView.separated(
      controller: scrollController,
      padding: const .symmetric(vertical: Insets.lg),
      reverse: true,
      separatorBuilder: (context, _) => Spaces.verticalLarge,
      itemCount: itemCount + 1,
      itemBuilder: (context, index) {
        if (index == itemCount) {
          if (isFetching) return const _LoadingIndicator();
          if (feed.hasReachedEnd) return const _BeginningOfChatIndicator();
          return const SizedBox.shrink();
        }

        final message = feed.getItemAtIndex(index);
        return ChatBubble(message: message);
      },
    );
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
      padding: const .all(16),
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
      padding: .all(16),
      child: Center(child: MLoadingIndicator.box()),
    );
  }
}
