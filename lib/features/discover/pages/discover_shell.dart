import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart' show FpdartOnIterable;
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/discover/discover.dart';
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
    return MScaffold(
      padding: .zero,
      appBar: AppBar(
        title: const MHeader(
          title: 'Discover',
          padding: .zero,
          addTopMargin: true,
        ),
        bottom: PreferredSize(
          preferredSize: const .fromHeight(110),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const DiscoverSearchBar(readOnly: true),
              Spaces.verticalXLarge,
              ChipTabBar(
                controller: _tabController,
                tabs: Filter.values.mapWithIndex((filter, index) {
                  return ChipTab(
                    label: filter.name,
                    index: index,
                    controller: _tabController,
                    icon: index == 1
                        ? Assets.images.flame.image(width: 16, height: 16)
                        : null,
                  );
                }).toList(),
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
