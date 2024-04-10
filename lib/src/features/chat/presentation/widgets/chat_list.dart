import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../auth/application/application.dart';
import '../../application/chat_bloc.dart';
import '../../domain/domain.dart';
import 'chat_bubble.dart';

class ChatList extends HookConsumerWidget {
  final String broadcastId;
  final ScrollController controller;

  const ChatList({
    super.key,
    required this.broadcastId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: context.read<ChatBloc>()..add(ChatEvent.getMessages(broadcastId)),
      buildWhen: (p, c) => p.chats != c.chats,
      builder: (context, state) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: MCore.large).r,
        controller: controller,
        reverse: true,
        shrinkWrap: true,
        separatorBuilder: (context, _) => MCore.large.verticalSpace,
        itemCount: state.chats.length,
        itemBuilder: (context, i) => _Item(chat: state.chats[i]!),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Chat chat;
  const _Item({required this.chat});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (credential) => GestureDetector(
          onLongPress: credential.user.id == chat.senderId
              ? () => showMyChatOptions(context)
              : () => showOtherChatOptions(context),
          child: ChatBubble(chat: chat),
        ),
      ),
    );
  }

  Future<dynamic> showMyChatOptions(BuildContext context) {
    return context.showModal(
      isScrollControlled: true,
      MModal(
        title: 'My Comment',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MCore.small.verticalSpace,
            MModalListTile(
              leading: const Icon(MIcons.edit_05),
              title: 'Edit',
              onTap: () {},
            ),
            MCore.large.verticalSpace,
            MModalListTile(
              leading: const Icon(MIcons.trash),
              title: 'Delete',
              onTap: () => context.showDeleteCommentDialog(),
              titleColor: MColorScheme.of(context)!.error,
            ),
            MCore.large.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<dynamic> showOtherChatOptions(BuildContext context) async {
    return context.showModal(
      isScrollControlled: true,
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
              title: 'Report',
              onTap: () {},
            ),
            MCore.large.verticalSpace,
          ],
        ),
      ),
    );
  }
}
