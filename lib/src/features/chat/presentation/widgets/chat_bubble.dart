import 'package:get_time_ago/get_time_ago.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final broadcast = getBroadcastFromContext(context);
    final isHost =
        (broadcast.creatorId ?? broadcast.creator?.id) == chat.senderId;

    final timeStamp = GetTimeAgo.parse(chat.updatedAt ?? chat.createdAt);

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
              url: chat.imageUrl,
              hasBorder: false,
              onTap: () => showUserInfo(context),
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
                      onTap: () => showUserInfo(context),
                      child: MText(
                        chat.fullName ?? chat.sender?.fullName ?? '',
                        style: textTheme.microMedium,
                        color: colors.onBackgroundVariant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spaces.horizontalMicro,
                    if (isHost) ...[
                      MDot(
                        dimension: 2,
                        color: colors.onBackgroundVariant,
                      ),
                      Spaces.horizontalMicro,
                      MText(
                        'Host',
                        style: textTheme.microMedium,
                        color: colors.onBackgroundVariant,
                      ),
                      Spaces.horizontalMicro,
                    ],
                    MDot(
                      dimension: 2,
                      color: colors.onBackgroundVariant,
                    ),
                    Spaces.horizontalMicro,
                    MText(
                      chat.updatedAt != null ? 'Edited $timeStamp' : timeStamp,
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
                    chat.content.getOr(),
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

  Future<dynamic> showUserInfo(BuildContext context) async {
    final currentUserId = context.read<SessionBloc>().state.whenOrNull(
          authenticated: (user, token) => user.id.getOr(),
        );

    if (currentUserId == chat.senderId) return;

    return context.showModal(
      MUserInfoModal(
        fullName: chat.fullName,
        imageUrl: chat.imageUrl,
        onSubscribe: () {},
        onViewAccount: () => router.push(
          Routes.othersProfile,
          extra: chat.senderId,
        ),
      ),
      isScrollControlled: true,
    );
  }
}

Broadcast getBroadcastFromContext(BuildContext context) {
  final broadcastBloc = context.read<BroadcastBloc>().state;
  final streamBloc = context.read<StreamBloc>().state;

  if (broadcastBloc.broadcast != Broadcast.empty()) {
    return broadcastBloc.broadcast;
  } else if (streamBloc.broadcast != Broadcast.empty()) {
    return streamBloc.broadcast;
  }

  throw Exception('No valid broadcast found in either bloc');
}
