import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

final _formKey = GlobalKey<FormState>();

class CreateBroadcastForm extends WatchingWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

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
      select: (BroadcastFormManager m) => m.errors,
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          CreateBroadcastListTile(
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

    final manager = di<BroadcastFormManager>();
    final image = watchValue((BroadcastFormManager m) => m.image);
    final imageValue = image.getOrNull() as LocalImage?;
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return Column(
      children: [
        MAvatar(radius: 48, file: imageValue?.file),
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

class _TitleField extends WatchingStatefulWidget {
  const _TitleField({super.key});

  @override
  State<_TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<_TitleField> {
  TextEditingController? _controller;
  final manager = di<BroadcastFormManager>();

  @override
  void initState() {
    super.initState();

    final initialValue = manager.title.value.getOrElse((_) => '');
    _controller = TextEditingController(text: initialValue);

    manager.title.listen((SingleLineString newValue, _) {
      _syncControllerWithManager(newValue);
    });
  }

  void _syncControllerWithManager(SingleLineString newValue) {
    final text = newValue.getOrElse((_) => '');
    if (_controller?.text != text) {
      _controller?.text = text;
      _controller?.selection = TextSelection.collapsed(offset: text.length);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);
    return MTextFormField(
      key: widget.key,
      label: 'Broadcast title',
      hint: "Jim Halpert's live audio",
      controller: _controller,
      onChanged: manager.onTitleChanged,
      textInputAction: TextInputAction.next,
      enabled: !isLoading,
    );
  }
}

class _DescriptionField extends WatchingStatefulWidget {
  const _DescriptionField({super.key});

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  TextEditingController? _controller;
  final manager = di<BroadcastFormManager>();

  @override
  void initState() {
    super.initState();
    final initialValue = manager.desc.value.getOrElse((_) => '');
    _controller = TextEditingController(text: initialValue);

    manager.desc.listen((MultiLineString newValue, _) {
      _syncControllerWithManager(newValue);
    });
  }

  void _syncControllerWithManager(MultiLineString newValue) {
    final text = newValue.getOrElse((_) => '');
    if (_controller?.text != text) {
      _controller?.text = text;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final description = watchValue((BroadcastFormManager m) => m.desc);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return MTextArea(
      key: widget.key,
      label: 'About broadcast',
      hint: 'Enter a brief description',
      maxLines: 5,
      maxLength: 244,
      controller: _controller,
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
      child: Row(
        children: [ParticipantItem(), Spaces.horizontalSmall, Wrap(spacing: 8)],
      ),
    );
  }
}

class RecordToggleSwitchField extends WatchingWidget {
  const RecordToggleSwitchField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BroadcastFormManager>();
    final record = watchValue((BroadcastFormManager m) => m.record);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return CreateBroadcastListTile(
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
    registerHandler(
      select: (BroadcastFormManager m) => m.saveBroadcastSession,
      handler: (context, newValue, cancel) {
        di<BroadcastFormManager>().resetForm.run();
        context.replace(R.liveSessionInitialization);
      },
    );

    final isValid = watchValue((BroadcastFormManager m) => m.isValid);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);
    final step = watchValue((BroadcastFormManager m) => m.step);

    final buttonLabel = switch (step) {
      .none => 'Start Broadcast',
      .created => 'Continue & Start',
      .started => 'Finalize Broadcast',
      .saved => 'Start Broadcast',
    };

    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: buttonLabel,
            loading: isLoading,
            disabled: isLoading || !isValid,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                di<BroadcastFormManager>().createBroadcast.run();
              }
            },
          ),
        ],
      ),
    );
  }
}
