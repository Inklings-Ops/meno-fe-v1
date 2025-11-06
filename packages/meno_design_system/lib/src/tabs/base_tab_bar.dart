import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// {@template base_tab_bar}
/// An abstract base class for creating different styles of tab bars.
///
/// This class provides common properties and logic for displaying a list
/// of tabs and managing the active tab using a [TabController].
///
/// Subclasses can extend this class to implement specific visual styles
/// for the tab bar.
/// {@endtemplate}
abstract class BaseTabBar extends HookWidget {
  /// Creates a new [BaseTabBar].
  const BaseTabBar({
    required this.tabs,
    required this.controller,
    this.type = MenoTabType.contained,
    this.isScrollable = true,
    this.height = 32.0,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  /// The list of tabs to display in the tab bar. Each item is a [MenoTab].
  final List<MenoTab> tabs;

  /// The [TabController] that manages the currently active tab index.
  final TabController controller;

  /// The visual style of the tab bar, either [MenoTabType.normal] or
  /// [MenoTabType.contained].
  final MenoTabType type;

  /// Whether the tab bar should be scrollable horizontally if the tabs
  /// exceed the available width.
  final bool isScrollable;

  /// The height of each tab in the tab bar.
  final double height;

  /// An optional callback that's called when the [TabBar] is tapped.
  ///
  /// The callback is applied to the index of the tab where the tap occurred.
  final void Function(int)? onTap;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Builds the widget for the tab bar.
  ///
  /// This method is responsible for rendering the individual tabs based on the
  /// provided data and the current state of the [TabController].
  ///
  /// It also applies the appropriate visual styling based on the [type]
  /// property.
  @override
  Widget build(BuildContext context) {
    final isNormal = type == MenoTabType.normal;

    final theme = MTabBarTheme.of(context);
    final styles = isNormal ? theme.normal : theme.contained;

    useListenable(controller);
    final currentIndex = controller.index;

    final length = tabs.length;

    final renderedTabs = List.generate(tabs.length, (index) {
      final data = tabs[index];
      final selected = index == currentIndex;

      final isLast = index == length - 1;
      final hasMargin = !isLast && !isNormal;
      final margin = hasMargin ? const EdgeInsets.only(right: 16) : null;

      final child = _TabChild(
        data: data,
        selected: selected,
        type: type,
        height: height.h,
        margin: margin,
      );

      return Tab(key: data.key, height: height.h, child: child);
    });

    return TabBar(
      tabs: renderedTabs,
      controller: controller,
      onTap: onTap,
      padding: padding,
      isScrollable: isScrollable,
      dividerColor: styles.dividerColor,
      dividerHeight: styles.dividerHeight,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.transparent,
      indicatorWeight: 0,
      splashFactory: NoSplash.splashFactory,
      // unselectedLabelColor: colors.labelHelp,
      tabAlignment: !isScrollable ? TabAlignment.fill : TabAlignment.start,
      labelPadding: EdgeInsets.zero,
      indicator: styles.indicator,
    );
  }
}

/// A private widget used to render the individual tab content.
///
/// This widget handles the visual styling of a single tab based on its
/// selected state and the overall tab bar type.
class _TabChild extends StatelessWidget {
  /// Creates a new [_TabChild].
  const _TabChild({
    required this.data,
    required this.selected,
    required this.type,
    required this.height,
    this.margin,
  });

  /// The data associated with this tab.
  final MenoTab data;

  /// Whether this tab is currently selected.
  final bool selected;

  /// The visual style of the tab bar.
  final MenoTabType type;

  /// The height of the tab.
  final double height;

  /// Optional margin to apply to the tab.
  final EdgeInsetsGeometry? margin;

  /// Builds the widget for the individual tab.
  ///
  /// This method determines the background and label colors based on whether
  /// the tab is selected and the tab bar type. It then renders the tab content
  /// (icon and text) within an animated container.
  @override
  Widget build(BuildContext context) {
    final isNormal = type == MenoTabType.normal;

    final theme = MTabBarTheme.of(context);
    final styles = isNormal ? theme.normal : theme.contained;

    final selectedBackgroundColor = styles.backgroundColor.selectedValue;
    final unselectedBackgroundColor = styles.backgroundColor.noneValue;

    final selectedLabelColor = styles.labelColor.selectedValue;
    final unselectedLabelColor = styles.labelColor.noneValue;

    final selectedIconTheme = styles.iconTheme.selectedValue;
    final unselectedIconTheme = styles.iconTheme.noneValue;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: height,
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 6).r,
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? selectedBackgroundColor : unselectedBackgroundColor,
        borderRadius: isNormal ? null : Corners.circle.r,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.icon != null) ...[
            IconTheme(
              data: selected ? selectedIconTheme! : unselectedIconTheme!,
              child: data.icon!,
            ),
            Spaces.verticalMicro,
          ],
          MText.caption(
            data.text,
            color: selected ? selectedLabelColor : unselectedLabelColor,
          ),
        ],
      ),
    );

    if (!isNormal) return Skeleton.unite(child: child);
    return child;
  }
}
