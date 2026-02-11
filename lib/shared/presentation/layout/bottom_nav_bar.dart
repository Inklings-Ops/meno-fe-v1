import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/core/core.dart';
import 'package:meno/shared/domain/domain.dart' show Destination;
import 'package:meno/shared/extensions/m_snack_bar_extension.dart';
import 'package:meno/shared/presentation/presentation.dart';
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

  void _onMicTap(BuildContext ctx) {
    final service = di<PermissionsService>();

    // Create permission context with UI callbacks
    final permissionContext = PermissionContext(
      showRationale: ctx.showPermissionRationale,
      showSettingsPrompt: ctx.showPermissionSettingsPrompt,
    );

    // Request all broadcast permissions
    service.requestBroadcastPermissions.run(permissionContext);

    // Check if we can proceed
    if (service.canBroadcast && ctx.mounted) {
      // Navigate to create broadcast screen
      ctx.push(R.createBroadcast);
    } else if (ctx.mounted) {
      ctx.showErrorSnackBar('Microphone permission is required to broadcast');
    }
  }
}
