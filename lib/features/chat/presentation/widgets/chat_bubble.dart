import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast_session.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/presentation/widgets/chat_options_modal.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends WatchingWidget {
  const ChatBubble({required this.message, super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final broadcast = di<BroadcastSession>().broadcast;
    final broadcastCreator = broadcast.effectiveCreatorId;
    final isHost = broadcastCreator == message.senderId;

    final userId = watchValue((UserManager m) => m.currentUserId);
    final isIAm = userId.fold(() => false, (id) => id == message.senderId);

    return GestureDetector(
      onLongPress: () => ChatMessageOptionsModal.show(
        context,
        message: message,
        isHost: isHost,
        isIAmSender: isIAm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _UserImage(
              key: const Key('chat-user-image'),
              message: message,
              onShowUserInfo: () => showUserInfo(context, isIAm),
            ),
            Spaces.horizontalSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChatMessageInfo(
                    key: const Key('chat-message-info'),
                    message: message,
                    onShowUserInfo: () => showUserInfo(context, isIAm),
                    isHost: isHost,
                  ),
                  Spaces.verticalMicro,
                  _ChatContent(
                    key: const Key('chat-message-content'),
                    content: message.content.getOrElse((_) => ''),
                    isHost: isHost,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showUserInfo(BuildContext context, bool isIAm) async {
    if (isIAm) return;
    return context.showModal(
      MUserInfoModal(
        fullName: message.effectiveSenderName.getOrElse((_) => ''),
        imageUrl: message.imageUrl,
        onSubscribe: () {},
        onViewAccount: () => context.push(
          R.profile(message.effectiveSenderId.getOrElse((_) => '')),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({
    required this.message,
    required this.onShowUserInfo,
    super.key,
  });

  final Message message;
  final VoidCallback onShowUserInfo;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      key: key,
      maxHeight: 24,
      maxWidth: 24,
      child: MAvatar(
        radius: 12,
        url: message.imageUrl,
        hasBorder: false,
        onTap: onShowUserInfo,
      ),
    );
  }
}

class _ChatMessageInfo extends StatelessWidget {
  const _ChatMessageInfo({
    required this.message,
    required this.onShowUserInfo,
    required this.isHost,
    super.key,
  });

  final Message message;
  final VoidCallback onShowUserInfo;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final timeStamp = timeago.format(message.updatedAt ?? message.createdAt);

    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onShowUserInfo,
          child: MText(
            message.effectiveSenderName.getOrElse((_) => ''),
            style: textTheme.microMedium,
            color: colors.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spaces.horizontalMicro,
        if (isHost) ...[
          MDot(dimension: 2, color: colors.onBackgroundVariant),
          Spaces.horizontalMicro,
          MText(
            'Host',
            style: textTheme.microMedium,
            color: colors.onBackgroundVariant,
          ),
          Spaces.horizontalMicro,
        ],
        MDot(dimension: 2, color: colors.onBackgroundVariant),
        Spaces.horizontalMicro,
        MText(
          message.updatedAt != null ? 'Edited $timeStamp' : timeStamp,
          style: textTheme.microMedium,
          color: colors.onBackgroundVariant,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ChatContent extends StatelessWidget {
  const _ChatContent({required this.content, required this.isHost, super.key});

  final String content;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      key: key,
      padding: const EdgeInsets.all(Insets.md),
      decoration: ShapeDecoration(
        color: isHost ? colors.secondaryContainer : colors.surfaceShade,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      child: MText(
        content,
        style: textTheme.captionRegular,
        color: isHost ? colors.onSecondaryContainer : colors.onPrimaryContainer,
      ),
    );
  }
}
