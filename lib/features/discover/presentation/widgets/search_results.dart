import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/discover/presentation/widgets/discover_pagination_indicator.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ResultList(result: []),
        Spaces.verticalXLarge,
        DiscoverPaginationIndicator(hasMore: false, isLoading: false),
        Spaces.verticalXLarge,
      ],
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.result});

  final List<Broadcast?> result;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 159.50 / 176,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      itemCount: result.length,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final broadcast = result[i]!;
        if (broadcast.endTime == null) {
          return LiveBroadcastCard(broadcast: broadcast);
        }

        return MCard.recentlyLive(
          title: broadcast.title.getOrCrash(),
          imageUrl: broadcast.imageUrl,
          host:
              broadcast.fullName?.getOrNull() ??
              broadcast.creatorFullName?.getOrNull() ??
              broadcast.creator?.fullName.getOrNull(),
          // onTap: () => router.pushNamed(
          //   'Broadcast Details',
          //   pathParameters: {'id': broadcast.id.getOrCrash()},
          // ),
        );
      },
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 152, width: 152),
          Spaces.verticalXLarge,
          MText(
            'No Results',
            style: textTheme.heading3Bold,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalMicro,
          MText(
            'Try a new search',
            style: textTheme.bodyRegular,
            color: colors.inActiveContainer,
          ),
        ],
      ),
    );
  }
}
