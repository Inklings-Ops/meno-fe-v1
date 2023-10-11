import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/broadcast_form/broadcast_form_notifier.dart';
import 'co_host_section.dart';
import 'create_broadcast_list_item.dart';

class CreateBroadcastForm extends HookConsumerWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode titleFocusNode = useFocusNode();
    final FocusNode descriptionFocusNode = useFocusNode();

    return Form(
      child: Builder(builder: (formContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MSize.verticalSpaceSmall,
            const _BroadcastArtworkField(),
            MSize.verticalSpaceLarge,
            _BroadcastTitleField(focusNode: titleFocusNode),
            24.verticalSpace,
            _BroadcastDescriptionField(focusNode: descriptionFocusNode),
            24.verticalSpace,
            const CoHostSection(),
            24.verticalSpace,
            const CreateBroadcastListItem(
              leadingText: "Remaining time today",
              subtitleText: "Your daily broadcast time will reset in 24hrs",
              trailing: MText("0hr 30min", style: MTextStyle.captionRegular),
            ),
            24.verticalSpace,
            const CreateBroadcastListItem(
              leadingText: "Enable recording",
              subtitleText: "Record your broadcast to listen back to later",
              trailing: _EnableRecordingSwitch(),
            ),
            24.verticalSpace,
            MPrimaryButton(
              label: "Start Broadcast",
              loading: ref.watch(broadcastFormProvider).loading,
              onPressed: () {
                focusScope.unfocus();
                if (Form.of(formContext).validate()) {
                  ref.read(broadcastFormProvider.notifier).createPressed();
                }
              },
            ),
            24.verticalSpace,
          ],
        );
      }),
    );
  }
}

class _BroadcastArtworkField extends ConsumerWidget {
  const _BroadcastArtworkField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        MAvatar(
          radius: 48,
          isArtwork: true,
          file: ref.watch(broadcastFormProvider).artwork?.get(),
        ),
        MTextButton(
          label: "Change Artwork",
          onPressed: () => showImageSourceModal(context, ref),
        ),
        const Center(
          child: SizedBox(
            width: 167,
            child: MText(
              "JPG or PNG accepted. Max size 10mb.",
              maxLines: 2,
              style: MTextStyle.microRegular,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> showImageSourceModal(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => MImageSourceModal(
        onGallerySourceTap: () {
          ref.read(broadcastFormProvider.notifier).artworkChanged(true);
        },
        onCameraSourceTap: () {
          ref.read(broadcastFormProvider.notifier).artworkChanged(false);
        },
      ),
    );
  }
}

class _BroadcastDescriptionField extends HookConsumerWidget {
  final FocusNode focusNode;

  const _BroadcastDescriptionField({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descController = useTextEditingController();

    return MTextFormField(
      label: "About Broadcast",
      hint: "Enter a brief description",
      maxLines: 5,
      maxLength: 244,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      controller: descController,
      enabled: !ref.watch(broadcastFormProvider).loading,
      onChanged: ref.watch(broadcastFormProvider.notifier).descriptionChanged,
      validator: ref.watch(broadcastFormProvider.notifier).validateDescription,
    );
  }
}

class _BroadcastTitleField extends ConsumerWidget {
  final FocusNode focusNode;

  const _BroadcastTitleField({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MTextFormField(
      label: "Broadcast Title",
      hint: "Jim Halpert's live audio",
      required: true,
      focusNode: focusNode,
      enabled: !ref.watch(broadcastFormProvider).loading,
      onChanged: ref.watch(broadcastFormProvider.notifier).titleChanged,
      validator: ref.watch(broadcastFormProvider.notifier).validateTitle,
    );
  }
}

class _EnableRecordingSwitch extends ConsumerWidget {
  const _EnableRecordingSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 48,
      child: Switch(
        value: ref.watch(broadcastFormProvider).recordingEnabled,
        onChanged: ref.read(broadcastFormProvider.notifier).onRecordingChanged,
      ),
    );
  }
}
