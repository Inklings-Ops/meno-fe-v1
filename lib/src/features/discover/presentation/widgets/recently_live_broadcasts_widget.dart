import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class RecentlyLiveBroadcastsWidget extends StatelessWidget {
  const RecentlyLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DRecentlyLiveCubit, DRecentlyLiveState>(
      buildWhen: (p, c) =>
          p.isLoading != c.isLoading || p.broadcasts != c.broadcasts,
      builder: (context, state) {
        if (!state.isLoading && state.hasError || state.broadcasts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: EmptyListWidget(),
          );
        }

        return Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: (159.50 / 176),
              ),
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
              itemBuilder: (context, i) {
                final broadcast = state.broadcasts[i]!;
                return MCard.recentlyLive(
                  title: broadcast.title.getOr(),
                  imageUrl: broadcast.imageUrl,
                  host: broadcast.fullName!,
                  onTap: () => context.push(Routes.details, extra: broadcast),
                );
              },
              itemCount: state.broadcasts.length,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
            ),
            Spaces.verticalXLarge,
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
