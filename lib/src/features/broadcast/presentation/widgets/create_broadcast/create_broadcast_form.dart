import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'broadcast_avatar_field.dart';
import 'broadcast_description_field.dart';
import 'broadcast_title_field.dart';
import 'co_host_section.dart';
import 'create_broadcast_list_item.dart';
import 'record_toggle_switch_field.dart';

class CreateBroadcastForm extends HookWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final descController = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MCore.small.verticalSpace,
        const BroadcastAvatarField(),
        MCore.large.verticalSpace,
        const BroadcastTitleField(),
        24.verticalSpace,
        BroadcastDescriptionField(descController),
        24.verticalSpace,
        const CoHostSection(),
        24.verticalSpace,
        const CreateBroadcastListItem(
          leadingText: 'Remaining time today',
          subtitleText: 'Your daily broadcast time will reset in 24hrs',
          trailing: MText('0hr 30min', style: MTextStyle.captionRegular),
        ),
        24.verticalSpace,
        const RecordToggleSwitchField(),
        24.verticalSpace,
      ],
    );
  }
}
