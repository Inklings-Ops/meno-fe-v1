import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../application/chat_bloc.dart';
import '../../domain/domain.dart';
import 'chat_bubble.dart';

class ChatList extends HookConsumerWidget {
  const ChatList({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<ChatBloc, ChatState>(
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
    final broadcast = context.select((ChatBloc bloc) => bloc.state.broadcast);
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) => GestureDetector(
          onLongPress: () {
            final isSender = user.id.getOr() == chat.senderId;
            final isHost = user.id.getOr() == broadcast.creator!.id;
            if (isSender) {
              showOtherChatOptions(context);
            } else {
              showOtherChatOptions(context, isHost: isHost);
            }
          },
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

  Future<dynamic> showOtherChatOptions(
    BuildContext context, {
    bool isHost = false,
  }) async {
    final colors = MColorScheme.of(context)!;
    return context.showModal(
      isScrollControlled: true,
      MModal(
        title: "User's Comment",
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MCore.small.verticalSpace,
            if (isHost)
              MModalListTile(
                leading: Icon(MIcons.trash, color: colors.error),
                title: 'Delete',
                onTap: () => context.read<ChatBloc>().deleteMessage(chat),
                titleColor: colors.error,
              )
            else
              MModalListTile(
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
