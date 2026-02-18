import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatWelcomeWidget extends WatchingWidget {
  const ChatWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = watchValue((ChatManager m) => m.welcomeMessageVisible);
    if (!isVisible) return const SizedBox.shrink();

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Container(
      height: 88,
      padding: const EdgeInsets.all(Insets.lg),
      margin: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(Insets.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Insets.xxl,
            height: Insets.xxl,
            padding: const EdgeInsets.symmetric(vertical: 10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.onPrimaryContainer,
              borderRadius: BorderRadius.circular(Insets.md),
            ),
            child: Assets.images.logoLight.svg(),
          ),
          Spaces.horizontalLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Insets.xxl,
                  child: MText(
                    '''Welcome to the live chat! We encourage you to be as interactive as you can.''',
                    style: textTheme.microRegular,
                  ),
                ),
                Spaces.verticalSmall,
                SizedBox(
                  height: Insets.lg,
                  child: MTextButton(
                    label: 'OK, THANK YOU',
                    onPressed: di<ChatManager>().hideWelcomeNote,
                    style: TextButton.styleFrom(
                      textStyle: textTheme.microMedium,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
