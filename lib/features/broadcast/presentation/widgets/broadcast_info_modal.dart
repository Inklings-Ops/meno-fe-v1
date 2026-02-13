import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/broadcast/presentation/widgets/broadcast_status_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastInfoModal extends WatchingWidget {
  const BroadcastInfoModal({
    required this.broadcast,
    super.key,
    this.isStreaming = false,
  });

  final bool isStreaming;
  final Broadcast broadcast;

  static Future<dynamic> show(
    BuildContext context, {
    required Broadcast broadcast,
    bool isStreaming = false,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) {
        return BroadcastInfoModal(
          broadcast: broadcast,
          isStreaming: isStreaming,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final status = watchValue((LiveSessionManager m) => m.liveStatus);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48, url: broadcast.imageUrl),
          Spaces.verticalSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: MText(
              broadcast.title.getOrCrash(),
              style: textTheme.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spaces.verticalMicro,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.effectiveCreatorName.getOrElse((_) => ''),
                  style: textTheme.captionRegular,
                ),
                Spaces.horizontalSmall,
                BroadcastStatusWidget(status: status),
              ],
            ),
          ),
          Spaces.verticalXLarge,
          if (isStreaming) ...[
            MModalListTile(
              leading: const Icon(MIcons.arrow_narrow_down_left),
              title: 'Minimize Stream',
              onTap: () => context.go(R.home),
            ),
            const MModalListTile(
              leading: Icon(MIcons.user_minus_01),
              title: 'Unsubscribe',
            ),
          ],
          const MModalListTile(leading: Icon(MIcons.share), title: 'Share'),
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }
}
