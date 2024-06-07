import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../services/meno/meno_bloc.dart';
import '../../../application/stream/stream_bloc.dart';
import '../../../domain/domain.dart';

class StreamModal extends StatelessWidget {
  final Broadcast broadcast;

  const StreamModal({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StreamBloc, StreamState>(
      listenWhen: (p, c) => p.onJoined != c.onJoined,
      listener: (context, state) {
        state.onJoined.fold(
          () => null,
          (a) => a.fold(
            (l) => context.showBroadcastError(l),
            (r) => context
              ..pop()
              ..push(Routes.stream),
          ),
        );
      },
      child: MModal(
        title: 'Stream',
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.22,
          minChildSize: 0.22,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TopSection(broadcast: broadcast),
                  24.verticalSpace,
                  _DescriptionSection(broadcast: broadcast),
                  24.verticalSpace,
                  MHeader(
                    title: 'Recent Broadcasts',
                    showSideBorder: false,
                    padding: EdgeInsets.zero,
                    action: InkWell(
                      onTap: () {},
                      child: MText(
                        'See all',
                        color: MColorScheme.of(context)!.onBackgroundVariant,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Broadcast broadcast;
  const _ActionButtons({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8).r,
    );

   
    final bloc = context.read<StreamBloc>();

    return SizedBox(
      height: 32.h,
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<StreamBloc, StreamState>(
              bloc: bloc,
              buildWhen: (p, c) => p.loading != c.loading,
              builder: (context, state) => MPrimaryButton(
                label: 'Join',
                onPressed: () => bloc.add(StreamEvent.join(broadcast.id)),
                loading: state.loading,
                disabled: context.read<MenoBloc>().state is! MOffAir,
                style: ElevatedButton.styleFrom(shape: shape),
              ),
            ),
          ),
          MCore.small.horizontalSpace,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: shape,
                side: BorderSide(color: colorScheme.outlineVariant3!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BroadcastArtwork extends StatelessWidget {
  final String? imageUrl;

  const _BroadcastArtwork({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final hasImage = imageUrl != null;

    DecorationImage? image;

    if (hasImage) {
      image = DecorationImage(
        image: CachedNetworkImageProvider(
          imageUrl!,
          maxHeight: 240,
          maxWidth: 240,
        ),
        fit: BoxFit.cover,
      );
    }

    final SizedBox placeholder = SizedBox(
      height: (142 * 0.4).h,
      child: colorScheme.brightness == Brightness.light
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );

    return Container(
      height: 142.r,
      width: 142.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16).r,
        border: Border.all(color: colorScheme.outlineVariant1!),
        image: image,
      ),
      child: hasImage ? null : Center(child: placeholder),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final Broadcast broadcast;

  const _DescriptionSection({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MIcons.menu_03, size: 16.r),
            MCore.small.horizontalSpace,
            const MText('Description', style: MTextStyle.subheadingMedium),
          ],
        ),
        MCore.large.verticalSpace,
        if (broadcast.description?.get() != null)
          MText(broadcast.description!.get()!),
      ],
    );
  }
}

class _TopSection extends StatelessWidget {
  final Broadcast broadcast;

  const _TopSection({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142.h,
      child: Row(
        children: [
          _BroadcastArtwork(imageUrl: broadcast.imageUrl),
          MCore.large.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.title.get()!,
                  style: MTextStyle.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                const MBadge.live(),
                6.verticalSpace,
                MText(
                  broadcast.creator!.fullName,
                  style: MTextStyle.captionRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                MCore.medium.verticalSpace,
                _ActionButtons(broadcast: broadcast),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
