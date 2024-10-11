import 'package:meno_fe_v1/meno.dart';

const List<Destination> _destinations = [
  Destination(icon: Icon(MIcons.home_04), label: 'Home'),
  Destination(icon: Icon(MIcons.compass), label: 'Discover'),
  Destination(icon: Icon(MIcons.file), label: 'Notes'),
  Destination(icon: Icon(MIcons.user_circle), label: 'Profile'),
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
        destinations: destinationWidgets(),
      ),
    );
  }

  List<Widget> destinationWidgets() {
    final widgets = <Widget>[];
    final itemCount = _destinations.length;
    for (var i = 0; i < itemCount; i++) {
      if (i == 2) {
        widgets.add(
          Microphone(onTap: () => router.push(Routes.createBroadcast)),
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
}
