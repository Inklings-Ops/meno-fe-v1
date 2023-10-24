import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
    List<Widget>? actions,
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
        _AppBarVariant.home => const Size.fromHeight(80.0),
        _AppBarVariant.primary => const Size.fromHeight(120.0),
        _AppBarVariant.secondary => const Size.fromHeight(kToolbarHeight),
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
    final colorScheme = MColorScheme.of(context)!;
    final styles = MNavigationStyles.of(context)!;
    final colorFilter = ColorFilter.mode(styles.accentColor!, BlendMode.srcIn);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.primary,
      flexibleSpace: SizedBox(
        height: 120 + MediaQuery.viewPaddingOf(context).top,
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.passthrough,
          children: [
            Container(
              margin: MediaQuery.viewPaddingOf(context),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (implyLeading) ...[
                    MBackButton.withText(
                      title: backText,
                      iconColor: colorScheme.onPrimary,
                      textStyle: styles.actionTextStyle,
                    ),
                    const SizedBox(height: 16),
                  ],
                  MText(
                    title,
                    style: MTextStyle.heading2Bold,
                    color: colorScheme.onPrimary,
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
    super.actions,
  }) : super._(
          variant: _AppBarVariant.home,
          child: _HomeAppBarImpl(
            title,
            onBackPressed: onBackPressed,
            centerTitle: centerTitle,
            actions: actions,
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
      title: MText(title),
      actions: actions,
    );
  }
}

class _HomeAppBarImpl extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final List<Widget>? actions;

  const _HomeAppBarImpl(
    this.title, {
    this.onBackPressed,
    this.centerTitle = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MText("Hello,", style: MTextStyle.captionRegular),
                    MText(title, style: MTextStyle.subheadingMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
