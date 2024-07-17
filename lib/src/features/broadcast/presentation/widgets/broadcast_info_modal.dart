import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/router/router.dart';

import '../../../../services/meno/meno_bloc.dart';

class BroadcastInfoModal extends StatelessWidget {
  final bool isStreaming;
  final Broadcast broadcast;

  const BroadcastInfoModal({
    super.key,
    required this.broadcast,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48.r, url: broadcast.imageUrl),
          MCore.small.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: MText(
              broadcast.title.getOr(),
              style: MTextStyle.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MCore.micro.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.creator!.fullName,
                  style: MTextStyle.captionRegular,
                ),
                MCore.small.horizontalSpace,
                const BroadcastStatusWidget(),
              ],
            ),
          ),
          24.verticalSpace,
          if (isStreaming) ...[
            MModalListTile(
              leading: const Icon(MIcons.arrow_narrow_down_left),
              title: 'Minimize Stream',
              onTap: () => context.go(Routes.home),
            ),
            const MModalListTile(
              leading: Icon(MIcons.user_minus_01),
              title: 'Unsubscribe',
            ),
          ],
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          if (!isStreaming)
            BlocBuilder<MenoBloc, MenoState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const SizedBox(),
                live: () => MModalListTile(
                  leading: Icon(MIcons.trash, color: colors.error),
                  title: 'Delete Broadcast',
                  titleColor: colors.error,
                  onTap: () {
                    final id = broadcast.id;
                    context
                      ..read<BroadcastBloc>().add(BroadcastDeleteRequested(id))
                      ..pop();
                  },
                ),
              ),
            ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
