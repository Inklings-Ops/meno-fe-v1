import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/model/entities/participant.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EndedBroadcastParticipantsWidget extends StatelessWidget {
  const EndedBroadcastParticipantsWidget({
    required this.allTimeCount,
    required this.recentParticipants,
    super.key,
  });

  final int allTimeCount;
  final List<Participant> recentParticipants;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    // Handle empty state
    if (allTimeCount == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40), // Placeholder height
          MText(
            'No listeners yet',
            style: textTheme.captionRegular,
            textAlign: TextAlign.center,
            color: colors.onBackgroundVariant,
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: .min,
      children: [
        // Avatar stack
        _AvatarStack(
          participants: recentParticipants,
          totalCount: allTimeCount,
        ),

        Spaces.verticalSmall,

        // Count text
        MText(
          _getPluralText(allTimeCount),
          style: textTheme.captionRegular,
          textAlign: .center,
        ),
      ],
    );
  }

  String _getPluralText(int count) =>
      count == 1 ? '$count person tuned in!' : '$count people tuned in!';
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.participants, required this.totalCount});

  final List<Participant> participants;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    // CMax 3 avatars
    final displayCount = participants.length.clamp(0, 3);
    final hasMore = totalCount > 3;

    // Calculate stack width based on number of avatars
    final stackWidth = _calculateStackWidth(displayCount, hasMore);

    return SizedBox(
      height: 40,
      width: stackWidth,
      child: Stack(
        alignment: .center,
        children: [
          // Show avatars (max 3)
          ...List.generate(
            displayCount,
            (index) => Positioned(
              left: index * 24.0,
              child: _Avatar(imageUrl: participants[index].imageUrl, size: 40),
            ),
          ),

          // Show count badge if more than 3
          if (hasMore)
            Positioned(
              left: displayCount * 24.0,
              child: _CountBadge(
                count: totalCount - 3,
                size: 40,
                backgroundColor: colors.primary,
                textStyle: textTheme.captionMedium,
              ),
            ),
        ],
      ),
    );
  }

  double _calculateStackWidth(int displayCount, bool hasMore) {
    if (displayCount == 0) return 0;

    // Base: first avatar (40px) + overlapping avatars (24px each)
    const avatarWidth = 40.0;
    const overlapWidth = 24.0;

    // Width = first avatar + (remaining avatars * overlap) + (badge if needed)
    final baseWidth = avatarWidth + ((displayCount - 1) * overlapWidth);
    final badgeWidth = hasMore ? overlapWidth + avatarWidth : 0;

    return baseWidth + badgeWidth;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: .circle,
        border: .all(color: colors.background, width: 2),
      ),
      child: MAvatar(radius: size / 2, url: imageUrl, hasBorder: false),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.count,
    required this.size,
    required this.backgroundColor,
    required this.textStyle,
  });

  final int count;
  final double size;
  final Color backgroundColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: .circle,
        color: backgroundColor,
        border: .all(color: colors.background, width: 2),
      ),
      child: Center(
        child: MText(
          '+$count',
          style: textStyle.copyWith(color: colors.onPrimary),
        ),
      ),
    );
  }
}
