import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/manager/discover_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({
    this.controller,
    this.showCancelButton = false,
    this.readOnly = false,
    super.key,
    this.padding,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final EdgeInsetsGeometry? padding;
  final bool showCancelButton;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Padding(
      padding: padding ?? const .symmetric(horizontal: Insets.lg),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: SearchBar(
                readOnly: readOnly,
                elevation: const WidgetStatePropertyAll(0),
                autoFocus: true,
                onTap: di<DiscoverManager>().openSearch,
                controller: controller,
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.search,
                hintText: 'Search broadcasts',
                hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
                padding: const WidgetStatePropertyAll(
                  .symmetric(horizontal: Insets.md),
                ),
                leading: const Icon(MIcons.search, size: Insets.lg),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFC2C7D0)),
                    borderRadius: Corners.sm,
                  ),
                ),
              ),
            ),
          ),
          if (showCancelButton) ...[
            Spaces.horizontalSmall,
            InkWell(
              onTap: di<DiscoverManager>().closeSearch,
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
