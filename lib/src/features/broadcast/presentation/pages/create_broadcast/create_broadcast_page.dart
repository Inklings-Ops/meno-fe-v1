import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast/broadcast_notifier.dart';
import 'create_broadcast_form.dart';

@RoutePage()
class CreateBroadcastPage extends HookConsumerWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(broadcastNotifierProvider, (previous, next) {
      next.onCreated.fold(
        () => null,
        (either) => either.fold(
          (l) => context.showBroadcastError(l),
          (r) => context.router.replace(const BroadcastRoute()),
        ),
      );
    });

    return MScaffold(
      appBar: MHeader(
        title: "Go Live Now",
        actionTitle: "Cancel",
        action: context.back,
      ),
      body: const SingleChildScrollView(
        child: CreateBroadcastForm(),
      ),
    );
  }
}
