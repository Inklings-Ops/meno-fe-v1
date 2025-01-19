import 'dart:io';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/permissions_service.dart';

const List<Destination> _destinations = [
  Destination(icon: Icon(MIcons.home_04), label: 'Home'),
  Destination(icon: Icon(MIcons.compass), label: 'Discover'),
  Destination(icon: Icon(MIcons.file_02), label: 'Notes'),
  Destination(icon: Icon(MIcons.user), label: 'Profile'),
];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.selectedIndex,
    super.key,
    this.onTap,
  });
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final navigationBarTheme = Theme.of(context).navigationBarTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: navigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(width: 0.8, color: colors.outlineVariant1!),
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
      if (i == 2) {
        widgets.add(
          Microphone(
            onTap: () async {
              final micPermissionGranted = await _handleMicPermission(context);
              if (!micPermissionGranted) return;

              if (Platform.isAndroid && context.mounted) {
                final bgGranted = await _handleBackgroundPermission(context);
                if (!bgGranted) return;
              }

              await router.push(Routes.createBroadcast);
            },
          ),
        );
      }
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

  Future<bool> _handleMicPermission(BuildContext context) async {
    try {
      final permissions = di<PermissionsService>();
      final granted = await permissions.requestMicPermissions(context);
      if (!granted && context.mounted) {
        final permissions = di<PermissionsService>();
        await permissions.promptRedirect(context, 'Microphone');
      }
      return granted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _handleBackgroundPermission(BuildContext context) async {
    return di<PermissionsService>().requestBackgroundProcesses(context);
  }
}
