import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CreateBroadcastPage extends WatchingWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);
    final manager = di<BroadcastFormManager>();

    callOnceAfterThisBuild((context) {
      final drafts = manager.drafts.value;
      if (drafts.isEmpty) return;
      BroadcastDraftModal.show(
        context,
        onDraftSelected: manager.loadDraft,
        onCreateNew: manager.resetForm.run,
      );
    });

    final colors = MColorScheme.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) manager.resetForm.run();
      },
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: MScaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            leadingWidth: 0,
            title: const MHeader(
              title: 'Go Live Now',
              padding: EdgeInsets.zero,
            ),
            actions: [
              InkWell(
                onTap: () {
                  manager.resetForm.run();
                  context.pop();
                },
                child: MText('Cancel', color: colors.onBackgroundVariant),
              ),
              Spaces.horizontalLarge,
            ],
          ),
          body: const SingleChildScrollView(child: CreateBroadcastForm()),
          persistentFooterButtons: const [StartBroadcastButton()],
        ),
      ),
    );
  }
}
