import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveListWidget extends StatelessWidget {
  const NowLiveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginatedBroadcastList(
      config: BroadcastListConfig(
        layout: BroadcastListLayout.grid,
        itemBuilder: _buildBroadcastCard,
        skeletonBuilder: _buildSkeletonCard,
      ),
    );
  }

  Widget _buildBroadcastCard(BuildContext context, Broadcast broadcast) {
    return LiveBroadcastCard(broadcast: broadcast);
  }

  Widget _buildSkeletonCard() {
    return MCard.live(title: BoneMock.title, host: BoneMock.fullName);
  }
}
