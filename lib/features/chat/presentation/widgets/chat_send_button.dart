import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatSendButton extends WatchingWidget {
  const ChatSendButton({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final content = watchValue((ChatManager m) => m.content);

    if (!content.isValid || content.getOrElse((_) => '').isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Spaces.horizontalSmall,
        MIconButton(
          icon: const Icon(MIcons.send),
          isFilled: true,
          fillColor: colors.primary,
          color: colors.onPrimary,
          size: 40,
          iconSize: 20,
          onPressed: () {
            FocusScope.of(context).unfocus();
            di<ChatManager>().sendMessage.run();
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}
