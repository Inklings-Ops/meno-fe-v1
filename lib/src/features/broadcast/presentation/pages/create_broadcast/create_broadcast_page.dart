import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast/broadcast_notifier.dart';
import 'create_broadcast_form.dart';

class CreateBroadcastPage extends ConsumerWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(broadcastNotifierProvider, (previous, next) {
      next.onCreated.fold(
        () => null,
        (either) => either.fold(
          (l) => context.showBroadcastError(l),
          (r) => context.replace(Routes.broadcast),
        ),
      );
    });

    return MScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.r),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: MHeader(
            title: "Go Live Now",
            actionTitle: "Cancel",
            action: context.pop,
          ),
        ),
      ),
      body: const SingleChildScrollView(child: CreateBroadcastForm()),
    );
  }
}
