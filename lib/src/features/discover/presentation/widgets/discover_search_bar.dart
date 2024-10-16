import 'package:meno_fe_v1/meno.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({
    super.key,
    this.onTap,
    this.onCancel,
    this.showCancelButton = false,
    this.height = 40,
    this.padding,
    this.onChanged,
    this.autofocus = false,
  });
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool showCancelButton;
  final double height;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: height,
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                autoFocus: autofocus,
                onTap: onTap,
                onChanged: onChanged,
                hintText: 'Search broadcasts or broadcasters',
                hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: Insets.md),
                ),
                leading: const Icon(MIcons.search, size: Insets.lg),
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xFFC2C7D0),
                  ),
                    borderRadius: Corners.sm,
                ),),
              ),
            ),
          ),
          if (showCancelButton) ...[
            Spaces.horizontalSmall,
            InkWell(
              onTap: onCancel,
              child: MText(
                'Cancel',
                style: textTheme.captionMedium,
                color: colors.inActive,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
