import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/broadcast_form/broadcast_form_notifier.dart';
import 'create_broadcast_form.dart';

@RoutePage()
class CreateBroadcastPage extends HookConsumerWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<BroadcastFormState>(broadcastFormProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showBroadcastFormError(failure),
          (_) async {
            Logger().f(_.toString());
          },
        ),
      );
    });

    return MScaffold(
      appBar: MHeader(
        title: "Go Live Now",
        actionTitle: "Cancel",
        action: context.back,
      ),
      isScrollable: true,
      body: const CreateBroadcastForm(),
    );
  }
}
