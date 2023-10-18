import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'co_host_list_tile.dart';

class AddCohostModal extends StatelessWidget {
  const AddCohostModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: "Add Co-host",
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MTextFormField(
              label: "Search",
              prefixIcon: MIcons.search,
              showLabel: false,
              hint: "Search",
            ),
            MSize.verticalSpaceLarge,
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(MIcons.info_circle, size: 16),
                MSize.horizontalSpaceMicro,
                MText("Select not more than 1 co-host"),
              ],
            ),
            MSize.verticalSpaceLarge,
            const CohostListTile(),
            24.verticalSpace,
            MSize.verticalSpaceLarge,
            MPrimaryButton(label: "Done", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
