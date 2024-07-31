import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

/// Enum representing different types of app bars.
enum _AppBarVariant { home, primary, secondary }

/// A factory class for creating different types of app bars.
class MAppBar extends _AppBar {
  /// Creates a primary app bar with the given title.
  ///
  /// This app bar typically has a back button and is used for navigation.
  ///
  /// * `title`: The title of the app bar.
  /// * `key`: The key for the widget.
  /// * `backText`: The text for the back button (optional). Defaults to an
  /// empty string.
  /// * `onBackPressed`: A callback function called when the back button is
  /// pressed (optional).
  /// * `implyLeading`: Whether to imply a leading icon (optional). Defaults
  /// to false.
  factory MAppBar.primary({
    required String title,
    Key? key,
    String backText,
    VoidCallback? onBackPressed,
    bool implyLeading,
  }) = _PrimaryAppBar;

  /// Creates a secondary app bar with the given title.
  ///
  /// This app bar is typically used for screens with less emphasis on
  /// navigation.
  ///
  /// * `title`: The title of the app bar.
  /// * `key`: The key for the widget.
  /// * `onBackPressed`: A callback function called when the back button is
  /// pressed (optional).
  /// * `centerTitle`: Whether to center the title (optional).
  /// Defaults to false.
  /// * `actions`: A list of widgets to display on the right side of the
  /// app bar (optional).
  factory MAppBar.secondary({
    required String title,
    Key? key,
    VoidCallback? onBackPressed,
    bool centerTitle,
    List<Widget>? actions,
  }) = _SecondaryAppBar;

  /// Creates a home app bar with the given title.
  ///
  /// This app bar is typically used for the main screen of an app.
  ///
  /// * `title`: The title of the app bar.
  /// * `key`: The key for the widget.
  /// * `centerTitle`: Whether to center the title (optional).
  /// Defaults to false.
  /// * `avatarImageUrl`: The URL of the user's avatar image (optional).
  /// * `onAvatarTap`: A callback function called when the avatar is tapped
  /// (optional).
  /// * `onNotificationBellTap`: A callback function called when the
  /// notification bell is tapped (optional).
  factory MAppBar.home({
    required String title,
    Key? key,
    bool centerTitle,
    String? avatarImageUrl,
    VoidCallback? onAvatarTap,
    VoidCallback? onNotificationBellTap,
  }) = _HomeAppBar;

  const MAppBar._({
    required super.title,
    required super.onBackPressed,
    required super.child,
    super.key,
    super.actions,
    super.centerTitle,
    super.variant,
  });
}

/// Base class for different app bar types.
abstract class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of _AppBar.
  ///
  /// * `title`: The title of the app bar.
  /// * `child`: The content of the app bar.
  /// * `key`: The key for the widget.
  /// * `actions`: A list of widgets to display on the right side of the
  /// app bar (optional).
  /// * `centerTitle`: Whether to center the title (optional).
  /// Defaults to false.
  /// * `onBackPressed`: A callback function called when the back button is
  /// pressed (optional).
  /// * `variant`: The type of app bar (optional).
  /// Defaults to `_AppBarVariant.primary`.
  const _AppBar({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.centerTitle = false,
    this.onBackPressed,
    this.variant = _AppBarVariant.primary,
  });

  /// The title of the app bar.
  final String title;

  /// The content of the app bar.
  final Widget child;

  /// A list of widgets to display on the right side of the app bar.
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool centerTitle;

  /// A callback function called when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The type of app bar.
  final _AppBarVariant variant;

  @override
  Size get preferredSize => switch (variant) {
        _AppBarVariant.home => ToolBarHeights.home,
        _AppBarVariant.primary => ToolBarHeights.primary,
        _AppBarVariant.secondary => ToolBarHeights.secondary,
      };

  @override
  Widget build(BuildContext context) => child;
}

class _PrimaryAppBar extends MAppBar {
  _PrimaryAppBar({
    required super.title,
    super.key,
    super.onBackPressed,
    String backText = 'Back',
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
  const _PrimaryAppBarImpl(
    this.title, {
    required this.backText,
    this.onBackPressed,
    this.implyLeading = true,
  });
  final String title;
  final String backText;
  final VoidCallback? onBackPressed;
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final styles = MNavigationStyles.of(context)!;
    final colorFilter = ColorFilter.mode(styles.accentColor!, BlendMode.srcIn);
    const toolbarHeight = 120.0;

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
              padding: const EdgeInsets.symmetric(horizontal: Insets.large),
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
                    Spaces.verticalLarge,
                  ],
                  MText(
                    title,
                    style: textTheme.heading2Bold,
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
    required super.title,
    super.key,
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
    required super.title,
    super.key,
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
  const _SecondaryAppBarImpl(
    this.title, {
    this.onBackPressed,
    this.centerTitle = false,
    this.actions,
  });
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final List<Widget>? actions;

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
  const _HomeAppBarImpl(
    this.title, {
    this.onBackPressed,
    this.centerTitle = false,
    this.avatarImageUrl,
    this.onAvatarTap,
    this.onNotificationBellTap,
  });
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final String? avatarImageUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationBellTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return AppBar(
      flexibleSpace: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: Insets.small),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MText('Hello,', style: textTheme.captionRegular),
                    MText(title, style: textTheme.subheadingMedium),
                  ],
                ),
              ),
              Spaces.horizontalSmall,
              Row(
                children: [
                  MIconButton(
                    icon: const Icon(MIcons.bell),
                    iconSize: 20,
                    onPressed: onNotificationBellTap,
                  ),
                  const SizedBox(width: 24),
                  MAvatar(
                    radius: Insets.large,
                    url: avatarImageUrl,
                    onTap: onAvatarTap,
                    hasBorder: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
