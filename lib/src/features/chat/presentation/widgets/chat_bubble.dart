import 'package:intl/intl.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final bloc = context.watch<ChatBloc>();
    final createdAt = formatDate(chat.createdAt);
    final isHost = bloc.state.broadcast.creator!.id == chat.senderId;
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
    // This is not proper. Will fix when data objects and dtos are organized
    if (chat.senderId == null && chat.sender == null) return;
    return context.showModal(
      _UserInfoModel(senderId: chat.senderId ?? chat.sender?.id ?? ''),
      isScrollControlled: true,
    );
  }
}

class _UserInfoModel extends HookWidget {
  const _UserInfoModel({required this.senderId});
  final String senderId;
  @override
  Widget build(BuildContext context) {
    Future<Profile?> getInfo() {
      return context.read<ChatBloc>().getSenderInfo(senderId);
    }

    final future = useMemoized(getInfo);
    final snapshot = useFuture(future);

    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    if (isLoading) {
      return const MUserInfoModal(loading: true);
    }

    if (!isLoading && snapshot.data == null) {
      return const MUserInfoModal(error: 'User was not found');
    }
    
    final profile = snapshot.data!;
    return MUserInfoModal(
      bio: profile.bio?.getOr(),
      fullName: profile.fullName.getOr(),
      imageUrl: profile.imageUrl,
      onSubscribe: () {},
      onViewAccount: () {},
    );
  }
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat.jm().format(date);
  }
}
