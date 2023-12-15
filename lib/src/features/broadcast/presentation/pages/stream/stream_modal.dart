import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/stream/stream_notifier.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/services/socket/socket_service.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../domain/domain.dart';

class StreamModal extends ConsumerWidget {
  final Broadcast broadcast;

  const StreamModal({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(streamNotifierProvider, (previous, next) {
      next.onJoined.fold(
        () => null,
        (a) => a.fold(
          (l) => context.showBroadcastError(l),
          (r) {
            Navigator.pop(context);
            context.go(Routes.stream);
          },
        ),
      );
    });

    return MModal(
      title: "Stream",
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
                  title: "Recent Broadcasts",
                  action: () {},
                  actionTitle: "See all",
                  showSideBorder: false,
                  padding: EdgeInsets.zero,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final Broadcast broadcast;
  const _ActionButtons({required this.broadcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8).r,
    );

    final notifier = ref.read(streamNotifierProvider.notifier);

    final streamLoading = ref.watch(streamNotifierProvider.select(
      (value) => value.loading,
    ));

    final socketLoading = ref.watch(socketServiceProvider.select(
      (value) => value.loading,
    ));

    return SizedBox(
      height: 32.h,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton(
              label: "Join",
              onPressed: () => notifier.joinBroadcast(broadcast.id),
              loading: streamLoading || socketLoading,
              style: ElevatedButton.styleFrom(shape: shape),
            ),
          ),
          MCore.small.horizontalSpace,
          Expanded(
            child: MSecondaryButton(
              label: "Share",
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
            const MText("Description", style: MTextStyle.subheadingMedium),
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
