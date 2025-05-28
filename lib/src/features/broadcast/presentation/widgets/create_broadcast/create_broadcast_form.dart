import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

final _formKey = GlobalKey<FormState>();

class CreateBroadcastForm extends HookWidget {
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
          CreateBroadcastListItem(
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
    final bloc = context.watch<BroadcastFormCubit>();
    final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.artwork != c.artwork,
      builder: (context, state) => Column(
        children: [
          MAvatar(radius: 48, file: state.artwork?.getOrCrash()),
          MTextButton(
            label: 'Change Artwork',
            onPressed: () {
              if (!status.isLoading) {
                context.showModal<void>(
                  MImageSourceModal(
                    onGallerySourceTap: bloc.artworkChanged,
                    onCameraSourceTap: () =>
                        bloc.artworkChanged(fromGallery: false),
                  ),
                );
              }
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
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.title != c.title,
      builder: (context, state) => MTextFormField(
        label: 'Broadcast title',
        hint: "Jim Halpert's live audio",
        required: true,
        enabled: !status.isLoading,
        textInputAction: TextInputAction.next,
        onChanged: context.read<BroadcastFormCubit>().titleChanged,
        validator: (_) => state.title.failureOrNull?.message,
      ),
    );
  }
}

class _DescriptionField extends HookWidget {
  const _DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final status = context.select((BroadcastBloc bloc) => bloc.state.status);
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.description != c.description,
      builder: (context, state) => MTextArea(
        label: 'About broadcast',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        controller: controller,
        enabled: !status.isLoading,
        onChanged: context.read<BroadcastFormCubit>().descriptionChanged,
        validator: (_) => state.description.failureOrNull?.message,
      ),
    );
  }
}

class StartBroadcastButton extends StatelessWidget {
  const StartBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final formBloc = context.watch<BroadcastFormCubit>();

    final broadcastBloc = context.watch<BroadcastBloc>();
    final isLoading = broadcastBloc.state.status.isLoading;

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
            disabled: isLoading || !formBloc.state.isFormValid,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                broadcastBloc.add(
                  BroadcastStartRequested(
                    title: formBloc.state.title,
                    description: formBloc.state.description,
                    artwork: formBloc.state.artwork,
                    cohosts: formBloc.state.cohosts,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
