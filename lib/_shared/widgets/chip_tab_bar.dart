import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Horizontally-scrollable chip-style [TabBar].
///
/// Each chip is self-contained — active/inactive state is managed inside
/// [ChipTab] via [AnimatedBuilder] on the [TabController]. No custom
/// indicator painter required.
class ChipTabBar extends StatelessWidget implements PreferredSizeWidget {
  const ChipTabBar({required this.tabs, required this.controller, super.key});

  final TabController controller;
  final List<ChipTab> tabs;

  static const double _chipHeight = 32;

  @override
  Size get preferredSize => const .fromHeight(_chipHeight);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _chipHeight,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: .start,
        indicator: const BoxDecoration(),
        indicatorSize: .tab,
        dividerHeight: 0,
        labelPadding: const .symmetric(horizontal: 8),
        padding: const .symmetric(horizontal: 8),
        labelColor: Colors.transparent,
        unselectedLabelColor: Colors.transparent,
        overlayColor: .all(Colors.transparent),
        tabs: tabs,
      ),
    );
  }
}

/// Renders the inactive pill fill behind a [ChipTab].
///
/// Uses the same [insets] as [_ChipTabIndicator] so the inactive pill is
/// pixel-identical in size/position to the active one.
class _InactiveChip extends StatelessWidget {
  const _InactiveChip({
    required this.insets,
    required this.fillColor,
    required this.child,
  });

  final EdgeInsetsGeometry insets;
  final Color fillColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: insets.resolve(Directionality.of(context)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: .circular(100),
        ),
        child: child,
      ),
    );
  }
}

/// A self-painting chip tab.
///
/// Reads its own selected state from [TabController] (via [AnimatedBuilder])
/// and renders the correct active/inactive pill — no custom indicator needed.
class ChipTab extends StatelessWidget {
  const ChipTab({
    required this.label,
    required this.index,
    required this.controller,
    this.icon,
    super.key,
  });

  final String label;
  final int index;
  final TabController controller;

  /// Optional trailing widget — any asset, emoji, [Icon], image, etc.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Use controller.index (settled) — gives a clean snap on release,
        // which is correct for chip tabs (no partial fill during swipe).
        final isSelected = controller.index == index;

        final bgColor = isSelected ? colors.primary : colors.inActiveContainer;
        final textColor = isSelected
            ? colors.onPrimary
            : colors.onInActiveContainer;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 32,
          padding: const .symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: .circular(100),
          ),
          child: Row(
            mainAxisSize: .min,
            spacing: 4,
            children: [
              MText(label, color: textColor, style: textTheme.captionMedium),
              if (icon != null) icon!,
            ],
          ),
        );
      },
    );
  }
}

/// Paints a filled pill as the active tab indicator.
class _ChipTabIndicator extends Decoration {
  const _ChipTabIndicator({
    required this.color,
    this.borderRadius = const .all(.circular(100)),
    this.insets = .zero,
  });

  final Color color;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry insets;

  _ChipTabIndicator _lerp(_ChipTabIndicator a, _ChipTabIndicator b, double t) {
    return _ChipTabIndicator(
      color: .lerp(a.color, b.color, t)!,
      borderRadius: .lerp(a.borderRadius, b.borderRadius, t)!,
      insets: .lerp(a.insets, b.insets, t)!,
    );
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is _ChipTabIndicator) return _lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is _ChipTabIndicator) return _lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _ChipPainter(this, onChanged);
}

class _ChipPainter extends BoxPainter {
  _ChipPainter(this._d, super.onChanged);

  final _ChipTabIndicator _d;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    assert(config.size != null, 'Size cannot be null');
    final rect = _d.insets
        .resolve(config.textDirection)
        .deflateRect(offset & config.size!);
    canvas.drawRRect(_d.borderRadius.toRRect(rect), Paint()..color = _d.color);
  }
}
