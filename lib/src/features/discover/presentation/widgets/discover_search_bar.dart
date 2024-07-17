import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
      padding: padding ?? const EdgeInsets.symmetric(horizontal: MCore.large).r,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: height.h,
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                autoFocus: autofocus,
                onTap: onTap,
                onChanged: onChanged,
                hintText: 'Search broadcasts or broadcasters',
                hintStyle:
                    const WidgetStatePropertyAll(MTextStyle.captionRegular),
                padding: WidgetStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: MCore.medium).r,
                ),
                leading: Icon(MIcons.search, size: 16.r),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC2C7D0)),
                  borderRadius: BorderRadius.circular(8),
                )),
              ),
            ),
          ),
          if (showCancelButton) ...[
            MCore.small.horizontalSpace,
            InkWell(
              onTap: onCancel,
              child: MText(
                'Cancel',
                style: MTextStyle.captionMedium,
                color: colors.inActive,
              ),
            )
          ],
        ],
      ),
    );
  }
}
