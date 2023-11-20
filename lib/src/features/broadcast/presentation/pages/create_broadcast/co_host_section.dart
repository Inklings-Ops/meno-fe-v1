import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../widgets/participant_item.dart';
import 'add_cohost_modal.dart';

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 72.h,
      child: Row(
        children: [
          ParticipantItem(
            onTap: () => context.showModal(
              const AddCohostModal(),
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.9,
              ),
            ),
          ),
          MCore.small.horizontalSpace,
          Wrap(
            spacing: 8.r,
            children: const [],
          ),
        ],
      ),
    );
  }
}
