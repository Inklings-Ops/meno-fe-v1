import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../auth/application/application.dart';
import '../../../profile/application/application.dart';
import '../../../profile/domain/domain.dart';
import '../../domain/domain.dart';

class ChatBubble extends HookConsumerWidget {
  final Chat chat;
  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final createdAt = DateFormat.jm().format(chat.createdAt);

    final future = useMemoized(
      () => ref.read(profileProvider(chat.senderId).future),
    );

    final snapshot = useFuture(future);

    final isSender = ref.read(userProvider).id == chat.senderId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LimitedBox(
            maxHeight: 24.r,
            maxWidth: 24.r,
            child: MAvatar(
              radius: 12.r,
              url: snapshot.data?.imageUrl,
              onTap:
                  !isSender ? () => showUserInfo(context, snapshot.data) : null,
            ),
          ),
          MCore.small.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (snapshot.connectionState == ConnectionState.waiting)
                      MShimmer(height: 12.h, width: 70.w)
                    else
                      InkWell(
                        onTap: !isSender
                            ? () => showUserInfo(context, snapshot.data)
                            : null,
                        child: MText(
                          snapshot.data!.fullName.get()!,
                          style: MTextStyle.microMedium,
                          color: colorScheme.onBackgroundVariant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    MCore.micro.horizontalSpace,
                    MDot(
                      dimension: 2.r,
                      color: colorScheme.onBackgroundVariant,
                    ),
                    MCore.micro.horizontalSpace,
                    MText(
                      createdAt,
                      style: MTextStyle.microMedium,
                      color: colorScheme.onBackgroundVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                MCore.micro.verticalSpace,
                Container(
                  padding: const EdgeInsets.all(12).r,
                  decoration: ShapeDecoration(
                    color: colorScheme.surfaceShade,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20).r,
                        topRight: const Radius.circular(20).r,
                        bottomRight: const Radius.circular(20).r,
                      ),
                    ),
                  ),
                  child: MText(
                    chat.content.get()!,
                    style: MTextStyle.captionRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showUserInfo(BuildContext context, Profile? profile) {
    return context.showModal(
      MUserInfoModal(
        bio: profile?.bio?.get(),
        fullName: profile!.fullName.get()!,
        imageUrl: profile.imageUrl,
        onSubscribe: () {},
        onViewAccount: () {},
      ),
      isScrollControlled: true,
    );
  }
}
