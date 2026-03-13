import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/discover/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverShell extends WatchingStatefulWidget {
  const DiscoverShell._({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => DiscoverShell._(
    key: const ValueKey<String>('DiscoverShell'),
    navigationShell: navigationShell,
    children: children,
  );

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<DiscoverShell> createState() => _DiscoverShellState();
}

class _DiscoverShellState extends State<DiscoverShell>
    with SingleTickerProviderStateMixin {
  // final _tabs = Filter.values.map((i) => MenoTab(text: i.name)).toList();

  late final TabController _tabController;

  StatefulNavigationShell get _shell => widget.navigationShell;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: _shell.currentIndex,
      length: Filter.values.length,
      vsync: this,
    );

    // Keep TabController → shell in sync when the user swipes.
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(DiscoverShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep shell → TabController in sync when navigation is driven
    // programmatically (e.g. context.go / deep link).
    if (_tabController.index != _shell.currentIndex) {
      _tabController.index = _shell.currentIndex;
    }
  }

  void _onTabChanged() {
    // addListener fires on animation ticks too — only act on settled index.
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == _shell.currentIndex) return;

    _shell.goBranch(
      _tabController.index,
      // Tapping the active tab pops to the branch root, mirroring
      // standard bottom-nav behaviour.
      initialLocation: _tabController.index == _shell.currentIndex,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (DiscoverManager manager) => manager.isSearchOpened,
      handler: (context, isSearchOpened, cancel) {
        if (isSearchOpened) context.push(R.discoverSearch);
      },
    );

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return MScaffold(
      padding: .zero,
      appBar: AppBar(
        title: const MHeader(
          title: 'Discover',
          padding: EdgeInsets.zero,
          addTopMargin: true,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              const SizedBox(height: 6),
              const DiscoverSearchBar(readOnly: true),
              Spaces.verticalXLarge,
              ChipTabBar(
                controller: _tabController,
                tabs: [
                  ChipTab(label: 'All', index: 0, controller: _tabController),
                  ChipTab(
                    label: 'Now live',
                    index: 1,
                    controller: _tabController,
                    icon: Assets.images.flame.image(width: 16, height: 16),
                  ),
                  ChipTab(
                    label: 'Recently live',
                    index: 2,
                    controller: _tabController,
                  ),
                  ChipTab(
                    label: 'Suggested',
                    index: 3,
                    controller: _tabController,
                  ),
                ],
              ),
              Spaces.verticalMicro,
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: widget.children),
    );
  }
}

/// Paints a filled pill as the active tab indicator.
class ChipTabIndicator extends Decoration {
  const ChipTabIndicator({
    required this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.insets = EdgeInsets.zero,
  });

  final Color color;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry insets;

  ChipTabIndicator _lerp(ChipTabIndicator a, ChipTabIndicator b, double t) {
    return ChipTabIndicator(
      color: Color.lerp(a.color, b.color, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      insets: EdgeInsetsGeometry.lerp(a.insets, b.insets, t)!,
    );
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is ChipTabIndicator) return _lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is ChipTabIndicator) return _lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _ChipPainter(this, onChanged);
}

class _ChipPainter extends BoxPainter {
  _ChipPainter(this._d, super.onChanged);

  final ChipTabIndicator _d;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    assert(config.size != null);
    final rect = _d.insets
        .resolve(config.textDirection)
        .deflateRect(offset & config.size!);
    canvas.drawRRect(_d.borderRadius.toRRect(rect), Paint()..color = _d.color);
  }
}

/// Horizontally-scrollable chip-style [TabBar].
///
/// Each chip is self-contained — active/inactive state is managed inside
/// [ChipTab] via [AnimatedBuilder] on the [TabController]. No custom
/// indicator painter required.
///
/// Spec:
///   Height   : 32px chip, 48px total bar (8px vertical padding each side)
///   H-padding: 16px inside chip
///   Spacing  : 16px between chips
class ChipTabBar extends StatelessWidget implements PreferredSizeWidget {
  const ChipTabBar({required this.tabs, required this.controller, super.key});

  final TabController controller;
  final List<ChipTab> tabs;

  static const double _chipHeight = 32;
  static const double _verticalPadding = 8;

  @override
  Size get preferredSize =>
      const Size.fromHeight(_chipHeight + _verticalPadding * 2);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,

      // Chips paint themselves — make the built-in indicator invisible.
      indicator: const BoxDecoration(),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0,

      // 8px each side → 16px gap between adjacent chips.
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8, // aligns first chip 16px from the edge (8 bar + 8 label)
        vertical: _verticalPadding,
      ),

      // Suppress TabBar's own label colouring — ChipTab owns its text colour.
      labelColor: Colors.transparent,
      unselectedLabelColor: Colors.transparent,

      // Disable the ink splash so taps don't show a ripple outside the chip.
      overlayColor: WidgetStateProperty.all(Colors.transparent),

      tabs: tabs,
    );
  }
}

/// Renders the inactive pill fill behind a [ChipTab].
///
/// Uses the same [insets] as [ChipTabIndicator] so the inactive pill is
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
          borderRadius: BorderRadius.circular(100),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text(
                label,
                style: textTheme.captionMedium.copyWith(color: textColor),
              ),
              if (icon != null) icon!,
            ],
          ),
        );
      },
    );
  }
}
