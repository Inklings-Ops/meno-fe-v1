import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast_session.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends WatchingWidget {
  const ChatBubble({required this.message, super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final broadcast = di<BroadcastSession>().broadcast;
    final broadcastCreator = broadcast.effectiveCreatorId;
    final isHost = broadcastCreator == message.senderId;

    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    final isIAm = currentUserIdOption.fold(
      () => false,
      (id) => id == message.senderId,
    );

    final timeStamp = timeago.format(message.updatedAt ?? message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LimitedBox(
            maxHeight: 24,
            maxWidth: 24,
            child: MAvatar(
              radius: 12,
              url: message.imageUrl,
              hasBorder: false,
              onTap: () => showUserInfo(context, isIAm),
            ),
          ),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => showUserInfo(context, isIAm),
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
                      message.updatedAt != null
                          ? 'Edited $timeStamp'
                          : timeStamp,
                      style: textTheme.microMedium,
                      color: colors.onBackgroundVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Spaces.verticalMicro,
                Container(
                  padding: const EdgeInsets.all(Insets.md),
                  decoration: ShapeDecoration(
                    color: isHost
                        ? colors.secondaryContainer
                        : colors.surfaceShade,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  child: MText(
                    message.content.getOrCrash(),
                    style: textTheme.captionRegular,
                    color: isHost
                        ? colors.onSecondaryContainer
                        : colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
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
