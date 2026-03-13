import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

const List<Destination> _destinations = [
  Destination(icon: Icon(MIcons.home_04), label: 'Home'),
  Destination(icon: Icon(MIcons.compass), label: 'Discover'),
  Destination(icon: Icon(MIcons.file_02), label: 'Notes'),
  Destination(icon: Icon(MIcons.user), label: 'Profile'),
];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.selectedIndex, super.key, this.onTap});

  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final navigationBarTheme = Theme.of(context).navigationBarTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: navigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(width: 0.8, color: colors.outlineVariant1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onTap,
        destinations: destinationWidgets(context),
      ),
    );
  }

  List<Widget> destinationWidgets(BuildContext context) {
    final widgets = <Widget>[];
    final itemCount = _destinations.length;

    for (var i = 0; i < itemCount; i++) {
      if (i == 2) widgets.add(Microphone(onTap: () => _onMicTap(context)));

      widgets.add(
        DestinationWidget(
          icon: _destinations[i].icon,
          label: _destinations[i].label,
          selected: selectedIndex == i,
          onTap: () => onTap?.call(i),
        ),
      );
    }

    return widgets;
  }

  Future<void> _onMicTap(BuildContext ctx) async {
    final service = di<PermissionsService>();

    // Create permission context with UI callbacks
    final permissionContext = PermissionContext(
      showRationale: ctx.showPermissionRationale,
      showSettingsPrompt: ctx.showPermissionSettingsPrompt,
    );

    // Request all broadcast permissions
    await service.requestBroadcastPermissions.runAsync(permissionContext);

    if (!ctx.mounted) return;

    // Check if we can proceed
    if (service.canBroadcast && ctx.mounted) {
      // Navigate to create broadcast screen
      await ctx.push(R.broadcastEditor);
    } else if (ctx.mounted) {
      ctx.showErrorSnackBar('Microphone permission is required to broadcast');
    }
  }
}

class DestinationWidget extends StatelessWidget {
  const DestinationWidget({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final navigationBarTheme = Theme.of(context).navigationBarTheme;
    const selectedState = <WidgetState>{WidgetState.selected};
    const unselectedState = <WidgetState>{};

    final selectedIconTheme = navigationBarTheme.iconTheme?.resolve(
      selectedState,
    );
    final unselectedIconTheme = navigationBarTheme.iconTheme?.resolve(
      unselectedState,
    );

    final selectedLabelStyle = navigationBarTheme.labelTextStyle?.resolve(
      selectedState,
    );
    final unselectedLabelStyle = navigationBarTheme.labelTextStyle?.resolve(
      unselectedState,
    );

    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 62.50,
          height: 56,
          decoration: BoxDecoration(color: navigationBarTheme.backgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: selected ? selectedIconTheme! : unselectedIconTheme!,
                child: icon,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: selected ? selectedLabelStyle : unselectedLabelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
