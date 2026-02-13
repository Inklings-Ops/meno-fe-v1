import 'package:flutter/material.dart';

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
