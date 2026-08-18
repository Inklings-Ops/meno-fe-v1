import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoSearchBar extends StatelessWidget {
  const MenoSearchBar({
    required this.hintText,
    super.key,
    this.focusNode,
    this.onChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
  });

  final String hintText;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return SearchBar(
      focusNode: focusNode,
      scrollPadding: EdgeInsets.zero,
      hintText: hintText,
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      enabled: enabled,
      trailing: trailing,
      leading: leading ?? const Icon(MIcons.search, size: 16),
      constraints: BoxConstraints.tight(const Size.fromHeight(40)),
      padding: const WidgetStatePropertyAll(.symmetric(horizontal: Insets.md)),
      hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: Corners.sm),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        final side = BorderSide(color: colors.inActive);
        if (states.contains(WidgetState.error)) {
          return side.copyWith(color: colors.error, width: 2);
        } else if (states.contains(WidgetState.disabled)) {
          return side.copyWith(color: colors.disabled);
        } else if (states.contains(WidgetState.focused)) {
          return side.copyWith(color: colors.primary, width: 2);
        } else if (states.contains(WidgetState.selected)) {
          return side.copyWith(color: colors.primary, width: 2);
        }
        return side;
      }),
      textStyle: WidgetStateTextStyle.resolveWith((states) {
        final baseTextStyle = textTheme.captionRegular;
        late Color color;
        if (states.contains(WidgetState.disabled)) {
          color = colors.inActive;
        } else if (states.contains(WidgetState.focused)) {
          color = colors.onBackground;
        } else if (states.contains(WidgetState.error)) {
          color = colors.onBackground;
        } else {
          color = colors.inActive;
        }
        return baseTextStyle.copyWith(color: color);
      }),
    );
  }
}
