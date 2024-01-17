import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../application/broadcast_form/broadcast_form_notifier.dart';
import 'co_host_section.dart';
import 'create_broadcast_list_item.dart';

class CreateBroadcastForm extends HookConsumerWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descController = useTextEditingController();

    final broadcastNotifier = ref.read(broadcastNotifierProvider.notifier);

    final isLoading = ref.watch(
      broadcastNotifierProvider.select((value) => value.loading),
    );

    final formNotifier = ref.read(broadcastFormNotifierProvider.notifier);
    final formState = ref.watch(broadcastFormNotifierProvider);

    return Form(
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MCore.small.verticalSpace,
            _Avatar(
              file: formState.artwork?.get(),
              onPressed: () => showImageSourceModal(context, ref),
            ),
            MCore.large.verticalSpace,
            MTextFormField(
              label: 'Broadcast Title',
              hint: "Jim Halpert's live audio",
              required: true,
              enabled: !isLoading,
              onChanged: formNotifier.titleChanged,
              validator: formNotifier.validateTitle,
              textInputAction: TextInputAction.next,
            ),
            24.verticalSpace,
            MTextArea(
              label: 'About Broadcast',
              hint: 'Enter a brief description',
              maxLines: 5,
              maxLength: 244,
              keyboardType: TextInputType.text,
              controller: descController,
              enabled: !isLoading,
              onChanged: formNotifier.descriptionChanged,
              validator: formNotifier.validateDescription,
            ),
            24.verticalSpace,
            const CoHostSection(),
            24.verticalSpace,
            const CreateBroadcastListItem(
              leadingText: 'Remaining time today',
              subtitleText: 'Your daily broadcast time will reset in 24hrs',
              trailing: MText('0hr 30min', style: MTextStyle.captionRegular),
            ),
            24.verticalSpace,
            CreateBroadcastListItem(
              leadingText: 'Enable recording',
              subtitleText: 'Record your broadcast to listen back to later',
              trailing: SizedBox(
                width: 48.w,
                child: Switch(
                  value: formState.recordingEnabled,
                  onChanged: formNotifier.onRecordingChanged,
                ),
              ),
            ),
            24.verticalSpace,
            MPrimaryButton(
              label: 'Start Broadcast',
              loading: isLoading,
              onPressed: () {
                context.clearSnackBars();
                FocusScope.of(context).unfocus();
                if (Form.of(formContext).validate()) {
                  broadcastNotifier.createPressed();
                }
              },
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<dynamic> showImageSourceModal(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(broadcastFormNotifierProvider.notifier);
    return context.showModal(MImageSourceModal(
      onGallerySourceTap: () => notifier.artworkChanged(true),
      onCameraSourceTap: () => notifier.artworkChanged(false),
    ));
  }
}

class _Avatar extends StatelessWidget {
  final File? file;
  final VoidCallback? onPressed;

  const _Avatar({this.file, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MAvatar(radius: 48.r, file: file),
        MTextButton(label: 'Change Artwork', onPressed: onPressed),
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
  }
}
