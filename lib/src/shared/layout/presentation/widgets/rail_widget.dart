import 'package:meno_fe_v1/meno.dart';

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
