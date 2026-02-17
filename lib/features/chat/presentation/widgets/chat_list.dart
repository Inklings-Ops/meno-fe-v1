import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatList extends WatchingWidget {
  const ChatList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final messages = watchValue((ChatListManager m) => m.messages);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      controller: scrollController,
      reverse: true,
      separatorBuilder: (context, _) => Spaces.verticalLarge,
      itemCount: messages.length,
      itemBuilder: (context, i) => ChatBubble(message: messages[i]),
    );
  }
}
