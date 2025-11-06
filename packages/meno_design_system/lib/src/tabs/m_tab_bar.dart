import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// {@template meno_tab_bar}
/// A concrete implementation of [BaseTabBar] providing factory constructors
/// for different tab bar styles.
/// {@endtemplate}
class MTabBar extends BaseTabBar {
  /// Creates a new [MTabBar].
  const MTabBar._({
    required super.tabs,
    required super.controller,
    super.isScrollable = true,
    super.key,
    super.type = MenoTabType.contained,
    super.padding,
    super.onTap,
  });

  /// Creates a [MTabBar] with the normal tab style.
  ///
  /// The normal style typically features an underline indicator for
  /// the selected tab.
  const factory MTabBar.normal({
    required List<MenoTab> tabs,
    required TabController controller,
    Key? key,
    bool isScrollable,
    void Function(int)? onTap,
    EdgeInsetsGeometry? padding,
  }) = _NormalMenoTabBar;

  /// Creates a [MTabBar] with the contained tab style.
  ///
  /// The contained style displays each tab as a separate, visually
  /// contained element.
  const factory MTabBar.contained({
    required List<MenoTab> tabs,
    required TabController controller,
    Key? key,
    bool isScrollable,
    void Function(int)? onTap,
    EdgeInsetsGeometry? padding,
  }) = _ContainedMenoTabBar;
}

/// Implementation for the normal style [MTabBar].
class _NormalMenoTabBar extends MTabBar {
  /// Creates a new [_NormalMenoTabBar].
  const _NormalMenoTabBar({
    required super.tabs,
    required super.controller,
    super.key,
    super.isScrollable = true,
    super.onTap,
    super.padding,
  }) : super._(type: MenoTabType.normal);
}

/// Implementation for the contained style [MTabBar].
class _ContainedMenoTabBar extends MTabBar {
  /// Creates a new [_ContainedMenoTabBar].
  const _ContainedMenoTabBar({
    required super.tabs,
    required super.controller,
    super.key,
    super.isScrollable = true,
    super.onTap,
    super.padding,
  }) : super._(type: MenoTabType.contained);
}
