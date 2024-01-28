import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast/broadcast_bloc.dart';
import '../../../application/broadcast_form/broadcast_form_cubit.dart';
import 'co_host_section.dart';
import 'create_broadcast_list_item.dart';

class CreateBroadcastForm extends StatelessWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final descController = useTextEditingController();

    return BlocListener<BroadcastFormCubit, BroadcastFormState>(
      bloc: context.read<BroadcastFormCubit>(),
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (l) => context.showBroadcastError(l),
            (r) {
              context.read<BroadcastBloc>().add(BroadcastEvent.initialize(r));
              context.replace(Routes.broadcast);
            },
          ),
        );
      },
      child: Form(
        child: Builder(
          builder: (formContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MCore.small.verticalSpace,
              const _Avatar(),
              MCore.large.verticalSpace,
              const _BroadcastTitle(),
              24.verticalSpace,
              _RecordSwitch(descController),
              24.verticalSpace,
              const CoHostSection(),
              24.verticalSpace,
              const CreateBroadcastListItem(
                leadingText: 'Remaining time today',
                subtitleText: 'Your daily broadcast time will reset in 24hrs',
                trailing: MText('0hr 30min', style: MTextStyle.captionRegular),
              ),
              24.verticalSpace,
              const _RecordToggleSwitch(),
              24.verticalSpace,
              const _CreateButton(),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.artwork != c.artwork,
      builder: (context, state) {
        return Column(
          children: [
            MAvatar(radius: 48.r, file: state.artwork?.get()),
            MTextButton(
              label: 'Change Artwork',
              onPressed: () => context.showModal(MImageSourceModal(
                onGallerySourceTap: () => bloc.artworkChanged(true),
                onCameraSourceTap: () => bloc.artworkChanged(false),
              )),
            ),
            Center(
              child: SizedBox(
                width: 167.w,
                child: const MText(
                  'JPG or PNG accepted. Max size 10mb.',
                  maxLines: 2,
                  style: MTextStyle.microRegular,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BroadcastTitle extends StatelessWidget {
  const _BroadcastTitle();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.title != c.title,
      builder: (context, state) => MTextFormField(
        label: 'Broadcast Title',
        hint: "Jim Halpert's live audio",
        required: true,
        enabled: !state.loading,
        onChanged: bloc.titleChanged,
        validator: bloc.validateTitle,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.shouldRecord != c.shouldRecord,
      builder: (context, state) => MPrimaryButton(
        label: 'Start Broadcast',
        loading: state.loading,
        onPressed: () {
          context.clearSnackBars();
          FocusScope.of(context).unfocus();
          if (bloc.isValid) {
            bloc.create();
          }
        },
      ),
    );
  }
}

class _RecordSwitch extends StatelessWidget {
  final TextEditingController controller;

  const _RecordSwitch(this.controller);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.description != c.description,
      builder: (context, state) => MTextFormField(
        label: 'About Broadcast',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        keyboardType: TextInputType.text,
        controller: controller,
        enabled: !state.loading,
        onChanged: bloc.descriptionChanged,
        validator: bloc.validateDescription,
      ),
    );
  }
}

class _RecordToggleSwitch extends StatelessWidget {
  const _RecordToggleSwitch();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.shouldRecord != c.shouldRecord,
      builder: (context, state) => CreateBroadcastListItem(
        leadingText: 'Enable recording',
        subtitleText: 'Record your broadcast to listen back to later',
        trailing: SizedBox(
          width: 48.w,
          child: Switch(
            value: state.shouldRecord,
            onChanged: bloc.onRecordingChanged,
          ),
        ),
      ),
    );
  }
}
