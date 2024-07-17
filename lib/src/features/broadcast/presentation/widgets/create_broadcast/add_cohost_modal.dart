import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'co_host_list_tile.dart';

class AddCohostModal extends StatelessWidget {
  const AddCohostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return MModal(
      title: 'Add Co-host',
      builder: (context) => SingleChildScrollView(
        padding: MediaQuery.viewInsetsOf(context).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MTextFormField(
              label: 'Search',
              prefixIcon: MIcons.search,
              showLabel: false,
              hint: 'Search',
            ),
            MCore.large.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  MIcons.info_circle,
                  size: 16.r,
                  color: colorScheme.onBackgroundVariant,
                ),
                MCore.micro.horizontalSpace,
                MText(
                  'Select not more than 1 co-host',
                  color: colorScheme.onBackgroundVariant,
                ),
              ],
            ),
            MCore.large.verticalSpace,
            const CohostListTile(),
            24.verticalSpace,
            MCore.large.verticalSpace,
            MPrimaryButton(label: 'Done', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
