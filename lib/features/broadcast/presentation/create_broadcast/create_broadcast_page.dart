import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/broadcast/applications/broadcast_form_manager.dart';
import 'package:meno/features/broadcast/presentation/create_broadcast/broadcast_draft_modal.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreateBroadcastView();
  }
}

class CreateBroadcastView extends StatefulWidget {
  const CreateBroadcastView({super.key});

  @override
  State<CreateBroadcastView> createState() => _CreateBroadcastViewState();
}

class _CreateBroadcastViewState extends State<CreateBroadcastView> {
  final _formKey = GlobalKey<FormState>();

  final _manager = di<BroadcastFormManager>();

  @override
  void initState() {
    super.initState();

    // Show draft selector modal after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDraftSelectorIfNeeded();
    });
  }

  void _showDraftSelectorIfNeeded() {
    final drafts = _manager.drafts.value;

    // Only show if there are drafts available
    if (drafts.isEmpty) return;

    BroadcastDraftModal.show(
      context,
      onDraftSelected: _manager.loadDraft,
      onCreateNew: _manager.resetForm.run,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _manager.resetForm.run();
      },
      child: Form(
        key: _formKey,
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
                  _manager.resetForm.run();
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
