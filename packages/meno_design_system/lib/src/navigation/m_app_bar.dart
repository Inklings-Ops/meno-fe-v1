import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

enum _AppBarVariant { home, primary, secondary }

class MAppBar extends _AppBar {
  factory MAppBar.primary({
    Key? key,
    required String title,
    String backText,
    VoidCallback? onBackPressed,
    bool implyLeading,
  }) = _PrimaryAppBar;

  factory MAppBar.secondary({
    Key? key,
    required String title,
    VoidCallback? onBackPressed,
    bool centerTitle,
    List<Widget>? actions,
  }) = _SecondaryAppBar;

  factory MAppBar.home({
    Key? key,
    required String title,
    bool centerTitle,
    String? avatarImageUrl,
    VoidCallback? onAvatarTap,
    VoidCallback? onNotificationBellTap,
  }) = _HomeAppBar;

  const MAppBar._({
    super.key,
    required super.title,
    required super.onBackPressed,
    required super.child,
    super.actions,
    super.centerTitle,
    super.variant,
  });
}

abstract class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final Widget child;
  final _AppBarVariant variant;

  const _AppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.onBackPressed,
    required this.child,
    this.variant = _AppBarVariant.primary,
  });

  @override
  Size get preferredSize => switch (variant) {
        _AppBarVariant.home => $styles.toolbarHeight.home,
        _AppBarVariant.primary => $styles.toolbarHeight.primary,
        _AppBarVariant.secondary => $styles.toolbarHeight.secondary,
      };

  @override
  Widget build(BuildContext context) => child;
}

class _PrimaryAppBar extends MAppBar {
  _PrimaryAppBar({
    super.key,
    required super.title,
    super.onBackPressed,
    String backText = "Back",
    bool implyLeading = true,
  }) : super._(
          child: _PrimaryAppBarImpl(
            title,
            backText: backText,
            onBackPressed: onBackPressed,
            implyLeading: implyLeading,
          ),
          variant: _AppBarVariant.primary,
        );
}

class _PrimaryAppBarImpl extends StatelessWidget {
  final String title;
  final String backText;
  final VoidCallback? onBackPressed;
  final bool implyLeading;

  const _PrimaryAppBarImpl(
    this.title, {
    required this.backText,
    this.onBackPressed,
    this.implyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final styles = MNavigationStyles.of(context)!;
    final colorFilter = ColorFilter.mode(styles.accentColor!, BlendMode.srcIn);
    final toolbarHeight = 120.toScale;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colors.primary,
      toolbarHeight: toolbarHeight,
      flexibleSpace: SafeArea(
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (implyLeading) ...[
                    MBackButton.withText(
                      title: backText,
                      iconColor: colors.onPrimary,
                      textStyle: styles.actionTextStyle,
                    ),
                    $styles.spaces.verticalLarge,
                  ],
                  MText(
                    title,
                    style: $styles.text.heading2Bold,
                    color: colors.onPrimary,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Assets.images.geometricLines.svg(colorFilter: colorFilter),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryAppBar extends MAppBar {
  _SecondaryAppBar({
    super.key,
    required super.title,
    super.onBackPressed,
    super.centerTitle = false,
    super.actions,
  }) : super._(
          variant: _AppBarVariant.secondary,
          child: _SecondaryAppBarImpl(
            title,
            onBackPressed: onBackPressed,
            centerTitle: centerTitle,
            actions: actions,
          ),
        );
}

class _HomeAppBar extends MAppBar {
  _HomeAppBar({
    super.key,
    required super.title,
    super.onBackPressed,
    super.centerTitle = false,
    String? avatarImageUrl,
    VoidCallback? onAvatarTap,
    VoidCallback? onNotificationBellTap,
  }) : super._(
          variant: _AppBarVariant.home,
          child: _HomeAppBarImpl(
            title,
            onBackPressed: onBackPressed,
            centerTitle: centerTitle,
            avatarImageUrl: avatarImageUrl,
            onAvatarTap: onAvatarTap,
            onNotificationBellTap: onNotificationBellTap,
          ),
        );
}

class _SecondaryAppBarImpl extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final List<Widget>? actions;

  const _SecondaryAppBarImpl(
    this.title, {
    this.onBackPressed,
    this.centerTitle = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const MBackButton(),
      centerTitle: centerTitle,
      title: MText(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        color: MColorScheme.of(context)?.onBackground,
      ),
      actions: actions,
    );
  }
}

class _HomeAppBarImpl extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final String? avatarImageUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationBellTap;

  const _HomeAppBarImpl(
    this.title, {
    this.onBackPressed,
    this.centerTitle = false,
    this.avatarImageUrl,
    this.onAvatarTap,
    this.onNotificationBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: $styles.insets.small),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ).radius,
          height: 56.toScale,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MText("Hello,", style: $styles.text.captionRegular),
                    MText(title, style: $styles.text.subheadingMedium),
                  ],
                ),
              ),
              $styles.spaces.horizontalSmall,
              Row(
                children: [
                  MIconButton(
                    icon: const Icon(MIcons.bell),
                    iconSize: 20.toScale,
                    onPressed: onNotificationBellTap,
                  ),
                  24.hSpace,
                  MAvatar(
                    radius: $styles.insets.large,
                    url: avatarImageUrl,
                    onTap: onAvatarTap,
                    hasBorder: false,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
