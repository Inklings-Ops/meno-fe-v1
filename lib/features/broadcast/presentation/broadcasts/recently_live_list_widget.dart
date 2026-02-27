import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Recently Live broadcasts list (List layout)
class RecentlyLiveListWidget extends StatelessWidget {
  const RecentlyLiveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedBroadcastList(
      config: BroadcastListConfig(
        itemBuilder: _buildBroadcastTile,
        skeletonBuilder: _buildSkeletonTile,
      ),
    );
  }

  Widget _buildBroadcastTile(BuildContext context, Broadcast broadcast) {
    return MRecentlyLiveListTile(
      title: broadcast.title.getOrCrash(),
      endTime: broadcast.endTime,
      imageUrl: broadcast.imageUrl,
      creator: broadcast.effectiveCreatorName.getOrNull(),
      onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
    );
  }

  Widget _buildSkeletonTile() {
    return MRecentlyLiveListTile(
      title: BoneMock.title,
      creator: BoneMock.fullName,
      endTime: DateTime.now(),
    );
  }
}
