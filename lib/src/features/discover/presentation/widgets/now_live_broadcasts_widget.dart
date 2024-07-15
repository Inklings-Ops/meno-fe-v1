import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';
import 'package:meno_fe_v1/src/shared/widgets/empty_list_widget.dart';

class NowLiveBroadcastsWidget extends StatelessWidget {
  const NowLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DNowLiveCubit, DNowLiveState>(
      buildWhen: (p, c) =>
          p.isLoading != c.isLoading || p.broadcasts != c.broadcasts,
      builder: (context, state) {
        if (!state.isLoading && state.hasError || state.broadcasts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 120.0).r,
            child: const EmptyListWidget(),
          );
        }

        return Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24.h,
                crossAxisSpacing: 24.w,
                childAspectRatio: (159.50 / 176).r,
              ),
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 0).r,
              itemBuilder: (context, i) {
                final broadcast = state.broadcasts[i]!;
                return MCard.live(
                  title: broadcast.title.getOr(),
                  imageUrl: broadcast.imageUrl,
                  host: broadcast.fullName!,
                  liveCount: broadcast.totalListeners,
                  onTap: () => context.showJoinLiveBroadcastModal(broadcast),
                );
              },
              itemCount: state.broadcasts.length,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
            ),
            24.verticalSpace,
            DiscoverPaginationIndicator(
              isLoading: state.isLoading,
              hasMore: state.hasMore,
            ),
          ],
        );
      },
    );
  }
}
