import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.badgeTitle,
    required this.broadcast,
    this.actionButtonLabel,
    this.onTap,
    this.action,
    super.key,
  });

  final String badgeTitle;
  final Broadcast broadcast;
  final VoidCallback? onTap;
  final String? actionButtonLabel;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: Insets.lg),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.circular(Insets.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Badge(badgeTitle: badgeTitle),
                    const SizedBox(height: 2),
                    _Title(title: broadcast.title.getOrCrash()),
                    _CreatorName(
                      fullName:
                          broadcast.creator?.fullName.getOrNull() ??
                          broadcast.creatorFullName?.getOrNull() ??
                          broadcast.fullName?.getOrNull() ??
                          '',
                    ),
                  ],
                ),
              ),
              Spaces.horizontalMedium,
              _ActionButton(label: actionButtonLabel, onPressed: action),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badgeTitle});

  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: colors.secondaryContainer,
          child: CircleAvatar(radius: 3, backgroundColor: colors.secondary),
        ),
        Spaces.horizontalMicro,
        MText(badgeTitle, style: textTheme.microMedium, color: colors.error),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({this.label, this.onPressed});

  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 32,
      maxWidth: 79,
      child: MDangerButton(
        label: label ?? '',
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      alignment: Alignment.centerLeft,
      child: MText(
        title,
        style: MTextTheme.of(context).captionMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _CreatorName extends StatelessWidget {
  const _CreatorName({required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    return MText(
      fullName,
      style: MTextTheme.of(context).captionRegular,
      color: MColorScheme.of(context).onBackgroundVariant,
    );
  }
}
