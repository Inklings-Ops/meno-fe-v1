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
    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: $styles.insets.large),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: height.toScale,
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                autoFocus: autofocus,
                onTap: onTap,
                onChanged: onChanged,
                hintText: 'Search broadcasts or broadcasters',
                hintStyle: WidgetStatePropertyAll($styles.text.captionRegular),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: $styles.insets.medium),
                ),
                leading: Icon(MIcons.search, size: $styles.insets.large),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.toScale,
                    color: const Color(0xFFC2C7D0),
                  ),
                  borderRadius: $styles.radius.small,
                )),
              ),
            ),
          ),
          if (showCancelButton) ...[
            $styles.spaces.horizontalSmall,
            InkWell(
              onTap: onCancel,
              child: MText(
                'Cancel',
                style: $styles.text.captionMedium,
                color: colors.inActive,
              ),
            )
          ],
        ],
      ),
    );
  }
}
