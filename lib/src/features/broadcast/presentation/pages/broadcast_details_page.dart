import 'package:cached_network_image/cached_network_image.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class BroadcastDetailsPage extends StatelessWidget {
  const BroadcastDetailsPage({required this.id, super.key});
  final Uid<Broadcast> id;

  @override
  Widget build(BuildContext context) {
    final fetch = BroadcastsFetchRequested(
      page: 1,
      sortBy: 'title',
      id: id,
      orderBy: OrderBy.ASC,
    );

    return BlocProvider(
      create: (_) => BroadcastsBloc(facade: di<IBroadcastFacade>())..add(fetch),
      child: const DetailsPageView(),
    );
  }
}

class DetailsPageView extends StatelessWidget {
  const DetailsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (SessionBloc bloc) => bloc.state.maybeWhen(
        orElse: User.empty,
        authenticated: (user, token) => user,
      ),
    );

    return BlocBuilder<BroadcastsBloc, BroadcastsState>(
      builder: (context, state) {
        if (state.status.isLoading) return const LoadingPage();

        if (state.status.isFailure && state.exception != null) {
          return MScaffold(
            appBar: MAppBar.secondary(
              title: 'Error loading broadcast',
              actions: const [
                MIconButton(icon: Icon(MIcons.star_border)),
                Spaces.horizontalLarge,
                MIconButton(
                  icon: Icon(MIcons.dots_horizontal),
                ),
                Spaces.horizontalLarge,
              ],
            ),
            body: ErrorWidget(state.exception!),
          );
        }

        if (state.status.isSuccess && state.broadcasts.isNotEmpty) {
          final broadcast = state.broadcasts.first!;
          return MScaffold(
            appBar: MAppBar.secondary(
              title: broadcast.title.getOr(),
              actions: [
                const MIconButton(icon: Icon(MIcons.star_border)),
                Spaces.horizontalLarge,
                MIconButton(
                  icon: const Icon(MIcons.dots_horizontal),
                  onPressed: () => context.showModal<void>(
                    DetailsPageOptionsModal(broadcast: broadcast),
                    isScrollControlled: true,
                  ),
                ),
                Spaces.horizontalLarge,
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Spaces.verticalLarge,
                  Align(child: _Artwork(imageUrl: broadcast.imageUrl)),
                  Spaces.verticalSmall,
                  _Time(
                    endTime: broadcast.endTime,
                    startTime: broadcast.startTime,
                  ),
                  Spaces.verticalMicro,
                  _Title(title: broadcast.title.getOr()),
                  Spaces.verticalMicro,
                  _Creator(
                    name: broadcast.fullName!,
                    onTap: () {
                      final userId =
                          broadcast.creatorId ?? broadcast.creator?.id;
                      if (userId == null) {
                        return;
                      } else if (userId == currentUser.id.getOr()) {
                        router.go(Routes.myProfile);
                      } else {
                        router.push(Routes.othersProfile, extra: userId);
                      }
                    },
                  ),
                  Spaces.verticalLarge,
                  MPrimaryButton.icon(
                    label: 'Restream',
                    icon: const Icon(MIcons.play_circle),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 40),
                  _Description(description: broadcast.description?.getOr()),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class DetailsPageOptionsModal extends StatelessWidget {
  const DetailsPageOptionsModal({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    final currentUser = context.select(
      (SessionBloc bloc) => bloc.state.maybeWhen(
        orElse: User.empty,
        authenticated: (user, token) => user,
      ),
    );
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(imageUrl: broadcast.imageUrl),
          Spaces.verticalSmall,
          _Title(title: broadcast.title.getOr()),
          Spaces.verticalMicro,
          MText(
            broadcast.fullName!,
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
          ),
          Spaces.verticalXLarge,
          MModalListTile(
            leading: const Icon(MIcons.user),
            title: 'Go to Profile',
            onTap: () async {
              final id = broadcast.creatorId ?? broadcast.creator?.id;
              if (id == null) {
                return;
              } else if (id == currentUser.id.getOr()) {
                await router.push(Routes.myProfile);
              } else {
                await router.push(Routes.othersProfile, extra: id);
              }
            },
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.user_minus_01),
            title: 'Unsubscribe',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.access_time),
            title: 'Listen Later',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          Spaces.verticalSmall,
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

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    const borderRadius = Corners.lg;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade!,
      BlendMode.srcIn,
    );

    Widget image = Center(
      child: Assets.images.logoLight.svg(
        colorFilter: colorFilter,
        height: 32,
      ),
    );

    if (imageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const MShimmer(borderRadius: 16),
      );
    }

    return Container(
      width: 201,
      height: 128,
      decoration: BoxDecoration(
        color: colors.surfaceShade,
        borderRadius: borderRadius,
      ),
      child: image,
    );
  }
}

class _Creator extends StatelessWidget {
  const _Creator({required this.name, this.onTap});
  final String name;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return SizedBox(
      height: 16,
      child: MTextButton.icon(
        label: name,
        icon: const Icon(MIcons.chevron_right),
        iconPlacement: MButtonIconPlacement.right,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: colors.onBackgroundVariant,
          iconColor: colors.onBackgroundVariant,
        ),
        onPressed: onTap,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            const Icon(MIcons.menu_03, size: 16),
            Spaces.horizontalSmall,
            MText('About Broadcast', style: textTheme.subheadingMedium),
          ],
        ),
        Spaces.verticalLarge,
        if (description != null)
          Align(
            alignment: Alignment.centerLeft,
            child: MText(description!),
          ),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({this.startTime, this.endTime});
  final DateTime? startTime;
  final DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (endTime != null)
          MText(
            DateHelpers.calculateTimeAgo(endTime!),
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
          ),
        if (startTime != null && endTime != null) ...[
          Spaces.horizontalSmall,
          const MDot(),
          Spaces.horizontalSmall,
          MText(
            DateHelpers.getTotalBroadcastTime(
              startTime: startTime!,
              endTime: endTime!,
            ),
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
          ),
        ],
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      height: 24,
      child: MText(
        title,
        style: textTheme.subheadingMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
