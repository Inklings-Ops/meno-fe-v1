import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
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
    // final bloc = context.watch<BroadcastFormCubit>();
    // final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return Column(
      children: [
        const MAvatar(
          radius: 48,
          // file: state.artwork?.getOrCrash(),
        ),
        MTextButton(
          label: 'Change Artwork',
          onPressed: () {
            // if (!status.isLoading) {
            //   context.showModal<void>(
            //     MImageSourceModal(
            //       onGallerySourceTap: bloc.artworkChanged,
            //       onCameraSourceTap: () =>
            //           bloc.artworkChanged(fromGallery: false),
            //     ),
            //   );
            // }
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

class _TitleField extends StatelessWidget {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    // final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return const MTextFormField(
      label: 'Broadcast title',
      hint: "Jim Halpert's live audio",
      required: true,
      textInputAction: TextInputAction.next,
      // enabled: !status.isLoading,
      // onChanged: context.read<BroadcastFormCubit>().titleChanged,
      // validator: (_) => state.title.failureOrNull?.message,
    );
  }
}

class _DescriptionField extends StatefulWidget {
  const _DescriptionField({super.key});

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return MTextArea(
      label: 'About broadcast',
      hint: 'Enter a brief description',
      maxLines: 5,
      maxLength: 244,
      controller: _controller,
      // enabled: !status.isLoading,
      // onChanged: context.read<BroadcastFormCubit>().descriptionChanged,
      // validator: (_) => state.description.failureOrNull?.message,
    );
  }
}

class StartBroadcastButton extends StatelessWidget {
  const StartBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    // final formBloc = context.watch<BroadcastFormCubit>();

    // final broadcastBloc = context.watch<BroadcastBloc>();
    // final isLoading = broadcastBloc.state.status.isLoading;

    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: 'Start Broadcast',
            // loading: isLoading,
            // disabled: isLoading || !formBloc.state.isFormValid,
            onPressed: () {
              // if (_formKey.currentState?.validate() ?? false) {
              //   broadcastBloc.add(
              //     BroadcastStartRequested(
              //       title: formBloc.state.title,
              //       description: formBloc.state.description,
              //       artwork: formBloc.state.artwork,
              //       cohosts: formBloc.state.cohosts,
              //     ),
              //   );
              // }
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

class RecordToggleSwitchField extends StatelessWidget {
  const RecordToggleSwitchField({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateBroadcastListTile(
      leadingText: 'Enable recording',
      subtitleText: 'Record your broadcast to listen back to later',
      trailing: SizedBox(
        width: 48,
        child: Switch(
          value: false,
          onChanged: (value) {},
          // value: state.shouldRecord,
          // onChanged: context.read<BroadcastFormCubit>().onRecordingChanged,
        ),
      ),
    );
  }
}
