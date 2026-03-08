import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/extensions/m_bottom_sheets_extensions.dart';
import 'package:meno/_shared/widgets/extensions/m_snack_bar_extension.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastEditorPage extends WatchingWidget {
  const BroadcastEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BroadcastEditorManager>();

    callOnceAfterThisBuild((context) {
      final drafts = manager.drafts.value;
      if (drafts.isEmpty) return;

      BroadcastDraftModal.show(
        context,
        onDraftSelected: manager.selectDraft.run,
        onCreateNew: manager.resetForm.run,
      );
    });

    registerHandler(
      select: (BroadcastEditorManager m) => m.saveBroadcastSession.results,
      handler: (context, result, cancel) {
        if (!result.isSuccess || result.hasData) return;
        di<BroadcastEditorManager>().resetForm.run();
        context.replace(R.liveSessionInitialization);
      },
    );

    final colors = MColorScheme.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) manager.resetForm.run();
      },
      child: MScaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          leadingWidth: 0,
          title: const MHeader(title: 'Go Live Now', padding: .zero),
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
        body: const SingleChildScrollView(child: _EditorFormWidget()),
        persistentFooterButtons: const [StartBroadcastButton()],
      ),
    );
  }
}

class _EditorFormWidget extends WatchingWidget {
  const _EditorFormWidget();

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);

    registerHandler(
      handler: (context, errors, cancel) {
        if (errors != null) {
          final message = switch (errors.error) {
            MenoException(:final message) => message,
            _ => errors.error.toString(),
          };
          context.showErrorSnackBar(message);
        }
      },
      select: (BroadcastEditorManager m) => m.errors,
    );

    final textTheme = MTextTheme.of(context);

    return Form(
      key: formKey,
      autovalidateMode: .onUserInteraction,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Spaces.verticalSmall,
          const _AvatarField(key: Key('broadcastForm_avatarField')),
          Spaces.verticalLarge,
          const _TitleField(key: Key('broadcastForm_titleField')),
          Spaces.verticalXLarge,
          const _DescriptionField(key: Key('broadcastForm_descriptionField')),
          Spaces.verticalXLarge,
          const CoHostSection(),
          Spaces.verticalXLarge,
          BroadcastEditorListTile(
            leadingText: 'Remaining time today',
            subtitleText: 'Your daily broadcast time will reset in 24hrs',
            trailing: MText('0hr 30min', style: textTheme.captionRegular),
          ),
          Spaces.verticalXLarge,
          const RecordToggleSwitchField(),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }
}

class _AvatarField extends WatchingWidget {
  const _AvatarField({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final manager = di<BroadcastEditorManager>();

    final isLoading = watchValue((BroadcastEditorManager m) => m.isRunning);
    final image = watchValue((BroadcastEditorManager m) => m.image);

    final imageValue = image.getFile();

    return Column(
      children: [
        MAvatar(radius: 48, file: imageValue),
        MTextButton(
          label: 'Change Artwork',
          onPressed: () {
            if (isLoading) return;
            context.showModal<void>(
              MImageSourceModal(
                onGallerySourceTap: manager.onImagePicked,
                onCameraSourceTap: () => manager.onImagePicked(false),
              ),
            );
          },
        ),
        Center(
          child: SizedBox(
            width: 167,
            child: MText(
              'JPG or PNG accepted. Max size 10mb.',
              maxLines: 2,
              style: textTheme.microRegular,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleField extends WatchingWidget {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BroadcastEditorManager>();

    final controller = createOnce(() {
      final initialText = manager.title.value.getOrElse((_) => '');
      return TextEditingController(text: initialText);
    });

    registerHandler(
      select: (BroadcastEditorManager m) => m.title,
      handler: (context, title, _) {
        final text = title.getOrElse((_) => '');
        if (controller.text != text) controller.text = text;
      },
    );

    final title = watchValue((BroadcastEditorManager m) => m.title);
    final isLoading = watchValue((BroadcastEditorManager m) => m.isRunning);

    return MTextFormField(
      key: key,
      label: 'Broadcast title',
      hint: "Jim Halpert's live audio",
      controller: controller,
      onChanged: manager.onTitleChanged,
      textInputAction: TextInputAction.next,
      enabled: !isLoading,
      validator: (_) => title.failureOrNull?.msg,
    );
  }
}

class _DescriptionField extends WatchingWidget {
  const _DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BroadcastEditorManager>();

    final controller = createOnce(() {
      final initialText = manager.desc.value.getOrElse((_) => '');
      return TextEditingController(text: initialText);
    });

    registerHandler(
      select: (BroadcastEditorManager m) => m.desc,
      handler: (context, desc, _) {
        final text = desc.getOrElse((_) => '');
        if (controller.text != text) controller.text = text;
      },
    );

    final description = watchValue((BroadcastEditorManager m) => m.desc);
    final isLoading = watchValue((BroadcastEditorManager m) => m.isRunning);

    return MTextArea(
      key: key,
      label: 'About broadcast',
      hint: 'Enter a brief description',
      maxLines: 5,
      maxLength: 244,
      controller: controller,
      onChanged: manager.onDescChanged,
      enabled: !isLoading,
      validator: (_) => description.failureOrNull?.msg,
    );
  }
}

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const LimitedBox(
      maxHeight: 72,
      child: Row(children: [Spaces.horizontalSmall, Wrap(spacing: 8)]),
    );
  }
}

class RecordToggleSwitchField extends WatchingWidget {
  const RecordToggleSwitchField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BroadcastEditorManager>();
    final record = watchValue((BroadcastEditorManager m) => m.record);
    final isLoading = watchValue((BroadcastEditorManager m) => m.isRunning);

    return BroadcastEditorListTile(
      leadingText: 'Enable recording',
      subtitleText: 'Record your broadcast to listen back to later',
      trailing: SizedBox(
        width: 48,
        child: Switch(
          value: record,
          onChanged: isLoading ? null : manager.onToggleRecord,
        ),
      ),
    );
  }
}

class StartBroadcastButton extends WatchingWidget {
  const StartBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isValid = watchValue((BroadcastEditorManager m) => m.isValid);
    final isLoading = watchValue((BroadcastEditorManager m) => m.isRunning);
    final step = watchValue((BroadcastEditorManager m) => m.step);

    final buttonLabel = switch (step) {
      .none => 'Start Broadcast',
      .created => 'Continue & Start',
      .started => 'Finalize Broadcast',
      .saved => 'Start Broadcast',
    };

    return Container(
      height: 77,
      padding: const .symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          MPrimaryButton(
            label: buttonLabel,
            loading: isLoading,
            disabled: isLoading || !isValid,
            onPressed: di<BroadcastEditorManager>().createBroadcast.run,
          ),
        ],
      ),
    );
  }
}
