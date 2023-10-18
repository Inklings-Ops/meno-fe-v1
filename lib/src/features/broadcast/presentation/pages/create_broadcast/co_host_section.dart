import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/co_host_item.dart';
import 'add_cohost_modal.dart';

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 72,
      child: Row(
        children: [
          CoHostItem(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.9,
              ),
              builder: (context) => const AddCohostModal(),
            ),
          ),
          MSize.horizontalSpaceSmall,
          const Wrap(
            spacing: 8,
            children: [],
          ),
        ],
      ),
    );
  }
}
