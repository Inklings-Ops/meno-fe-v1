import 'package:flutter/material.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/model/destination.dart';
import 'package:meno_design_system/meno_design_system.dart';

const List<Destination> _destinations = [
  Destination(icon: Icon(MIcons.home_04), label: 'Home'),
  Destination(icon: Icon(MIcons.compass), label: 'Discover'),
  Destination(icon: Icon(MIcons.file_02), label: 'Notes'),
  Destination(icon: Icon(MIcons.user), label: 'Profile'),
];

class SideNavRail extends StatelessWidget {
  const SideNavRail({
    required this.selectedIndex,
    super.key,
    this.onTap,
    this.currentRoute,
  });

  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(right: BorderSide(color: colors.outlineVariant1)),
      ),
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onTap,
        minWidth: 56,
        minExtendedWidth: 204,
        leading: Container(
          margin: const EdgeInsets.only(top: Insets.md, bottom: Insets.xxl),
          alignment: Alignment.center,
          child: Assets.images.menoPurple.image(height: 24),
        ),
        destinations: _destinations.map((destination) {
          final index = _destinations.indexOf(destination);
          final selected = selectedIndex == index;
          return NavigationRailDestination(
            icon: RailWidget(
              selected: selected,
              label: destination.label,
              icon: destination.icon,
              onTap: () => onTap?.call(index),
            ),
            label: MText(destination.label),
          );
        }).toList(),
        trailing: Column(
          children: [
            Spaces.verticalXLarge,
            RailWidget(
              selected: false,
              label: 'Settings',
              icon: const Icon(MIcons.settings),
              onTap: () => context.push(R.settings),
            ),
            Spaces.verticalXLarge,
            SizedBox(
              height: 48,
              child: GestureDetector(
                onTap: () => context.push<void>(R.webCreateBroadcast),
                child: const Microphone(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RailWidget extends StatelessWidget {
  const RailWidget({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
    this.extended = false,
    super.key,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final navigationRailTheme = Theme.of(context).navigationRailTheme;
    final iconWidget = IconTheme(
      data: selected
          ? navigationRailTheme.selectedIconTheme!
          : navigationRailTheme.unselectedIconTheme!,
      child: icon,
    );
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: Corners.md,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
          decoration: BoxDecoration(
            color: selected ? colors.primaryContainer : null,
            borderRadius: Corners.md,
          ),
          child: !extended
              ? iconWidget
              : Row(
                  children: [
                    iconWidget,
                    Spaces.horizontalSmall,
                    Text(
                      label,
                      style: selected
                          ? navigationRailTheme.selectedLabelTextStyle
                          : navigationRailTheme.unselectedLabelTextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
