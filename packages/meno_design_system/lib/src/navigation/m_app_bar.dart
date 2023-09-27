import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

enum _AppBarVariant { primary, secondary }

class MAppBar extends _AppBar {
  factory MAppBar.primary({
    Key? key,
    required String title,
    VoidCallback? onBackPressed,
  }) = _PrimaryAppBar;

  factory MAppBar.secondary({
    Key? key,
    required String title,
    VoidCallback? onBackPressed,
    bool centerTitle,
    List<Widget>? actions,
  }) = _SecondaryAppBar;

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
  }) : super._(
          child: _PrimaryAppBarImpl(title, onBackPressed: onBackPressed),
          variant: _AppBarVariant.primary,
        );
}

class _PrimaryAppBarImpl extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const _PrimaryAppBarImpl(this.title, {this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final styles = MAppBarStyles.of(context)!;
    final colorFilter = ColorFilter.mode(styles.accentColor!, BlendMode.srcIn);

    return AppBar(
      backgroundColor: styles.backgroundColor,
      flexibleSpace: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Container(
            height: 70,
            margin: MediaQuery.viewPaddingOf(context),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MBackButton.withText(
                  iconColor: styles.actionTextStyle?.color,
                  textStyle: styles.actionTextStyle,
                ),
                const SizedBox(height: 16),
                MText(title, style: styles.textStyle),
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
