import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

final _formKey = GlobalKey<FormState>();

class CreateBroadcastForm extends StatelessWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
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

class _AvatarField extends StatelessWidget {
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

class _TitleField extends WatchingWidget {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final title = watchValue((BroadcastFormManager m) => m.title);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return MTextFormField(
      label: 'Broadcast title',
      hint: "Jim Halpert's live audio",
      required: true,
      textInputAction: TextInputAction.next,
      enabled: !isLoading,
      onChanged: di<BroadcastFormManager>().onTitleChanged,
      validator: (_) => title.failureOrNull?.msg,
    );
  }
}

class _DescriptionField extends WatchingStatefulWidget {
  const _DescriptionField({super.key});

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final description = watchValue((BroadcastFormManager m) => m.desc);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return MTextArea(
      label: 'About broadcast',
      hint: 'Enter a brief description',
      maxLines: 5,
      maxLength: 244,
      controller: _controller,
      enabled: !isLoading,
      onChanged: di<BroadcastFormManager>().onDescChanged,
      validator: (_) => description.failureOrNull?.msg,
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
        context.replace(R.broadcastTab);
      },
    );

    final isValid = watchValue((BroadcastFormManager m) => m.isValid);
    final isLoading = watchValue((BroadcastFormManager m) => m.isRunning);

    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: 'Start Broadcast',
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

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const LimitedBox(
      maxHeight: 72,
      child: Row(
        children: [
          // ParticipantItem(
          //   onTap: () => context.showModal<void>(
          //     const AddCohostModal(),
          //     isScrollControlled: true,
          //     constraints: BoxConstraints(
          //       maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          //     ),
          //   ),
          // ),
          Spaces.horizontalSmall,
          Wrap(spacing: 8),
        ],
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
