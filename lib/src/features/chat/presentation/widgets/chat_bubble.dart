import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final bloc = context.watch<ChatBloc>();
    final isHost = bloc.state.broadcast.creator!.id == chat.senderId;
final createdAt = GetTimeAgo.parse(chat.createdAt);
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
                      onTap: !isHost ? () => showUserInfo(context) : null,
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
                      createdAt,
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
    return context.showModal(
      _UserInfoModel(chat: chat),
      isScrollControlled: true,
    );
  }
}

class _UserInfoModel extends HookWidget {
  const _UserInfoModel({required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return MUserInfoModal(
      fullName: chat.fullName,
      imageUrl: chat.imageUrl,
      onSubscribe: () {},
      onViewAccount: () {},
    );
  }
}

String formatDate(DateTime date) {
  final difference = DateTime.now().difference(date.toLocal());

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat.jm().format(date);
  }
}
