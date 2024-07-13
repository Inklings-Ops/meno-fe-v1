import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/gen/assets.gen.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<SearchBloc>();
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isLoading) return const MLoadingIndicator.box();

        if (!state.isLoading &&
            state.keyword != null &&
            state.searchResults.isEmpty) {
          return const _NoResultsWidget();
        }

        return Column(
          children: [
            _ResultList(result: state.searchResults),
            24.verticalSpace,
            DiscoverPaginationIndicator(
              isLoading: bloc.state.isSearchingMore,
              hasMore: bloc.state.hasMore,
            ),
            24.verticalSpace,
          ],
        );
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.result});
  final List<Broadcast?> result;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24.h,
        crossAxisSpacing: 24.w,
        childAspectRatio: (159.50 / 176).r,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32).r,
      itemCount: result.length,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final broadcast = result[i]!;

        if (broadcast.endTime == null) {
          return MCard.live(
            title: broadcast.title.get()!,
            imageUrl: broadcast.imageUrl,
            host: broadcast.fullName!,
            liveCount: broadcast.totalListeners,
            onTap: () => context.showJoinLiveBroadcastModal(broadcast),
          );
        }

        return MCard.recentlyLive(
          title: broadcast.title.get()!,
          imageUrl: broadcast.imageUrl,
          host: broadcast.fullName,
          onTap: () => context.push(Routes.details, extra: broadcast),
        );
      },
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 152.h, width: 152.w),
          24.verticalSpace,
          const MText(
            'No Results',
            style: MTextStyle.heading3Bold,
            textAlign: TextAlign.center,
          ),
          MCore.micro.verticalSpace,
          MText(
            'Try a new search',
            style: MTextStyle.bodyRegular,
            color: colors.inActiveContainer,
          ),
        ],
      ),
    );
  }
}
