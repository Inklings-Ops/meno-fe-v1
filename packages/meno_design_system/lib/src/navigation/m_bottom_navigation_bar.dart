import 'package:flutter/material.dart';
import 'package:meno_design_system/src/m_decorations.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:meno_design_system/src/theme/m_color.dart';
import 'package:meno_design_system/src/theme/m_icons.dart';

/// A customizable bottom navigation bar widget for your Flutter app.
///
/// The [MBottomNavigationBar] widget is designed to provide a responsive
/// and customizable bottom navigation bar that supports multiple items.
///
/// Example:
/// ```dart
/// MBottomNavigationBar(
///   currentIndex: _selectedIndex,
///   items: [
///     BottomNavigationBarItem(
///       icon: Icon(Icons.home),
///       label: 'Home',
///     ),
///     BottomNavigationBarItem(
///       icon: Icon(Icons.search),
///       label: 'Search',
///     ),
///     BottomNavigationBarItem(
///       icon: Icon(Icons.favorite),
///       label: 'Favorites',
///     ),
///     BottomNavigationBarItem(
///       icon: Icon(Icons.person),
///       label: 'Profile',
///     ),
///   ],
///   onTap: (index) {
///     // Handle navigation to the selected tab.
///   },
/// )
/// ```
class MBottomNavigationBar extends StatefulWidget {
  /// The index of the currently selected item.
  final int currentIndex;

  /// The list of [BottomNavigationBarItem]s that define each item in the bar.
  final List<BottomNavigationBarItem> items;

  /// A callback function called when an item is tapped.
  final ValueChanged<int>? onTap;

  /// Creates an [MBottomNavigationBar] widget.
  const MBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.items,
    this.onTap,
  }) : super(key: key);

  @override
  State<MBottomNavigationBar> createState() => _MBottomNavigationBarState();
}

class _MBottomNavigationBarState extends State<MBottomNavigationBar> {
  // Number of items in the navigation bar
  static const int itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final theme = Theme.of(context).bottomNavigationBarTheme;

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border(
          top: BorderSide(
            width: 0.80,
            color: MInternal.resolve(isLight, MColor.grey30, MColor.grey400),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildNavigationTiles(),
      ),
    );
  }

  // Build the list of navigation tiles
  List<Widget> _buildNavigationTiles() {
    final tiles = <Widget>[];

    for (var i = 0; i < itemCount; i++) {
      if (i == 2) {
        tiles.add(
          _NavigationItem(
            indexLabel: "Create",
            selected: false,
            onTap: () {},
            item: const BottomNavigationBarItem(
              icon: Icon(MIcons.microphone),
              label: "Create",
            ),
          ),
        );
      }
      tiles.add(
        _NavigationItem(
          indexLabel: widget.items[i].label,
          onTap: () => widget.onTap?.call(i),
          item: widget.items[i],
          selected: i == widget.currentIndex,
        ),
      );
    }

    return tiles;
  }
}

/// A responsive and customizable item for a bottom navigation bar.
///
/// The [_NavigationItem] widget is designed to create individual items for
/// a bottom navigation bar. It supports icons, labels, and tooltips for
/// each item.
class _NavigationItem extends StatelessWidget {
  /// The [BottomNavigationBarItem] to display.
  final BottomNavigationBarItem item;

  /// A label associated with the index for accessibility.
  final String? indexLabel;

  /// A callback function called when the item is tapped.
  final VoidCallback onTap;

  /// Indicates whether this item is currently selected.
  final bool selected;

  /// Creates a [_NavigationItem] widget.
  const _NavigationItem({
    required this.item,
    this.indexLabel,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;

    final String? effectiveTooltip =
        item.tooltip == '' ? null : item.tooltip ?? item.label;

    final Widget content = item.label == "Create"
        ? const _Microphone()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme(
                data: selected
                    ? theme.selectedIconTheme!
                    : theme.unselectedIconTheme!,
                child: item.icon,
              ),
              const SizedBox(height: 6),
              Text(
                item.label!,
                style: selected
                    ? theme.selectedLabelStyle
                    : theme.unselectedLabelStyle,
              ),
            ],
          );

    final Widget result = InkWell(
      onTap: onTap,
      child: Container(
        color: theme.backgroundColor,
        width: 62.50,
        height: 56,
        child: content,
      ),
    );

    Widget finalResult = result;

    if (effectiveTooltip != null) {
      finalResult = Tooltip(
        message: effectiveTooltip,
        preferBelow: false,
        verticalOffset: 50,
        excludeFromSemantics: true,
        child: result,
      );
    }

    finalResult = Semantics(
      selected: selected,
      container: true,
      child: Stack(
        children: <Widget>[
          finalResult,
          Semantics(label: indexLabel),
        ],
      ),
    );

    return finalResult;
  }
}

const double _kMicSize = 56.0;
const BoxConstraints _kConstraints = BoxConstraints(
  minWidth: _kMicSize,
  minHeight: _kMicSize,
);

/// A microphone icon widget with custom styling.
///
/// The [_Microphone] widget displays a microphone icon with custom styling.
class _Microphone extends StatelessWidget {
  /// Creates a [_Microphone] widget.
  const _Microphone();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final VisualDensity visualDensity = theme.visualDensity;

    return Container(
      height: _kMicSize,
      width: _kMicSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
        boxShadow: MDecorations.micBoxShadow,
      ),
      constraints: visualDensity.effectiveConstraints(_kConstraints),
      child: Icon(MIcons.microphone, color: colorScheme.onPrimary),
    );
  }
}
