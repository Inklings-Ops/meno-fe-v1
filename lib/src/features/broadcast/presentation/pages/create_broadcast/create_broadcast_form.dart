import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../application/broadcast_form/broadcast_form.dart';
import 'co_host_section.dart';
import 'create_broadcast_list_item.dart';

class CreateBroadcastForm extends HookConsumerWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();

    final TextEditingController descController = useTextEditingController();

    final broadcastNotifier = ref.read(broadcastNotifierProvider.notifier);

    final formNotifier = ref.read(broadcastFormProvider.notifier);
    final formState = ref.watch(broadcastFormProvider);

    return Form(
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MSize.verticalSpaceSmall,
            Column(
              children: [
                MAvatar(
                  radius: 48,
                  isArtwork: true,
                  file: formState.artwork?.get(),
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
            ),
            MSize.verticalSpaceLarge,
            MTextFormField(
              label: "Broadcast Title",
              hint: "Jim Halpert's live audio",
              required: true,
              focusNode: focusScope,
              enabled: !formState.loading,
              onChanged: formNotifier.titleChanged,
              validator: formNotifier.validateTitle,
            ),
            24.verticalSpace,
            MTextFormField(
              label: "About Broadcast",
              hint: "Enter a brief description",
              maxLines: 5,
              maxLength: 244,
              focusNode: focusScope,
              keyboardType: TextInputType.text,
              controller: descController,
              enabled: !formState.loading,
              onChanged: formNotifier.descriptionChanged,
              validator: formNotifier.validateDescription,
            ),
            24.verticalSpace,
            const CoHostSection(),
            24.verticalSpace,
            const CreateBroadcastListItem(
              leadingText: "Remaining time today",
              subtitleText: "Your daily broadcast time will reset in 24hrs",
              trailing: MText("0hr 30min", style: MTextStyle.captionRegular),
            ),
            24.verticalSpace,
            CreateBroadcastListItem(
              leadingText: "Enable recording",
              subtitleText: "Record your broadcast to listen back to later",
              trailing: SizedBox(
                width: 48,
                child: Switch(
                  value: formState.recordingEnabled,
                  onChanged: formNotifier.onRecordingChanged,
                ),
              ),
            ),
            24.verticalSpace,
            MPrimaryButton(
              label: "Start Broadcast",
              loading: formState.loading,
              onPressed: () {
                focusScope.unfocus();
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
