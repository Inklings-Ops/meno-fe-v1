import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'create_broadcast_form.dart';

class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.r),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: MHeader(
            title: 'Go Live Now',
            actionTitle: 'Cancel',
            action: context.pop,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: CreateBroadcastForm(),
      ),
    );
  }
}
