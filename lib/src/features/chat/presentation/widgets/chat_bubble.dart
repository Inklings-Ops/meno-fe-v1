import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../profile/domain/domain.dart';

class ChatBubble extends StatelessWidget {
  final Chat chat;
  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ChatBloc>();
    final colors = MColorScheme.of(context)!;
    final createdAt = formatDate(chat.createdAt);
    final isHost = bloc.state.broadcast.creator!.id == chat.senderId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LimitedBox(
            maxHeight: 24.r,
            maxWidth: 24.r,
            child: MAvatar(radius: 12.r, url: chat.imageUrl, hasBorder: false),
          ),
          MCore.small.horizontalSpace,
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
                        chat.fullName,
                        style: MTextStyle.microMedium,
                        color: colors.onBackgroundVariant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MCore.micro.horizontalSpace,
                    if (isHost) ...[
                      MDot(
                        dimension: 2.r,
                        color: colors.onBackgroundVariant,
                      ),
                      MCore.micro.horizontalSpace,
                      MText(
                        'Host',
                        style: MTextStyle.microMedium,
                        color: colors.onBackgroundVariant,
                      ),
                      MCore.micro.horizontalSpace,
                    ],
                    MDot(
                      dimension: 2.r,
                      color: colors.onBackgroundVariant,
                    ),
                    MCore.micro.horizontalSpace,
                    MText(
                      createdAt,
                      style: MTextStyle.microMedium,
                      color: colors.onBackgroundVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                MCore.micro.verticalSpace,
                Container(
                  padding: const EdgeInsets.all(MCore.medium).r,
                  decoration: ShapeDecoration(
                    color: isHost
                        ? colors.secondaryContainer
                        : colors.surfaceShade,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20).r,
                        topRight: const Radius.circular(20).r,
                        bottomRight: const Radius.circular(20).r,
                      ),
                    ),
                  ),
                  child: MText(
                    chat.content.getOr(),
                    style: MTextStyle.captionRegular,
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

  Future<dynamic> showUserInfo(BuildContext context) {
    return context.showModal(
      _UserInfoModel(senderId: chat.senderId),
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
