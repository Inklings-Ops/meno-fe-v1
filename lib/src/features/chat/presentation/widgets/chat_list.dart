import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../auth/application/application.dart';
import '../../application/chat_notifier.dart';
import '../../domain/domain.dart';
import 'chat_bubble.dart';

class ChatList extends HookConsumerWidget {
  final ScrollController controller;

  const ChatList({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatNotifierProvider);

    if (chats.isEmpty) {
      return const SizedBox();
    }

    final currentUserId = useMemoized(() => ref.read(userProvider).id);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: MCore.large).r,
      controller: controller,
      reverse: true,
      shrinkWrap: true,
      separatorBuilder: (context, _) => MCore.large.horizontalSpace,
      itemCount: chats.length,
      itemBuilder: (context, i) => GestureDetector(
        onLongPress: currentUserId == chats[i]!.senderId
            ? () => showMyChatOptions(context)
            : () => showOtherChatOptions(context, chats[i]!),
        child: ChatBubble(chat: chats[i]!),
      ),
    );
  }

  Future<dynamic> showMyChatOptions(BuildContext context) {
    return context.showModal(
      MModal(
        title: "My Comment",
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MCore.small.verticalSpace,
            MModalListTile(
              leading: const Icon(MIcons.edit_05),
              title: "Edit",
              onTap: () {},
            ),
            MCore.large.verticalSpace,
            MModalListTile(
              leading: const Icon(MIcons.trash),
              title: "Delete",
              onTap: () => context.showDeleteCommentDialog(),
              titleColor: MColorScheme.of(context)!.error,
            ),
            MCore.large.verticalSpace,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<dynamic> showOtherChatOptions(BuildContext context, Chat chat) async {
    return context.showModal(
      MModal(
        title: "User's Comment",
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MCore.small.verticalSpace,
            MModalListTile(
              // TODO: Add flag
              leading: const Icon(Icons.flag),
              title: "Report",
              onTap: () {},
            ),
            MCore.large.verticalSpace,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
