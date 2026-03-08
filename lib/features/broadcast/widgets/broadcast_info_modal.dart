import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/broadcast/manager/live_session_manager.dart';
import 'package:meno/features/broadcast/model/entities/broadcast.dart';
import 'package:meno/features/broadcast/widgets/live_broadcast_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastInfoModal extends WatchingWidget {
  const BroadcastInfoModal._({
    required this.broadcast,
    this.isStreaming = false,
    super.key,
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
      builder: (_) => BroadcastInfoModal._(
        key: const ValueKey<String>('BroadcastInfoModal'),
        broadcast: broadcast,
        isStreaming: isStreaming,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = watchValue((LiveSessionManager m) => m.status);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: .min,
        children: [
          BroadcastArtworkWidget(imageUrl: broadcast.imageUrl),
          Spaces.verticalSmall,
          BroadcastTitleWidget(
            title: broadcast.title,
            maxLines: 1,
            padding: const .symmetric(horizontal: 40),
          ),
          Spaces.verticalMicro,
          Padding(
            padding: const .symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                BroadcastCreatorWidget(name: broadcast.hostName),
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
            MModalListTile(
              leading: const Icon(MIcons.user_minus_01),
              title: 'Unsubscribe',
              onTap: () {},
            ),
          ],
          MModalListTile(
            leading: const Icon(MIcons.share),
            title: 'Share',
            onTap: () {},
          ),
          MModalListTile(
            leading: const Icon(MIcons.link_02),
            title: 'Copy Link',
            onTap: () {},
          ),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }
}
