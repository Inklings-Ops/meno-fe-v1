import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MImageSourceModal extends StatelessWidget {
  const MImageSourceModal({
    super.key,
    required this.onCameraSourceTap,
    required this.onGallerySourceTap,
  });

  final VoidCallback onCameraSourceTap;
  final VoidCallback onGallerySourceTap;

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: "Choose Artwork",
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(MIcons.pause_circle),
            title: const MText("Choose from Camera"),
            onTap: () {
              onCameraSourceTap();
              Navigator.of(context).pop();
            },
          ),
          MSize.verticalSpaceLarge,
          ListTile(
            leading: const Icon(MIcons.image),
            title: const MText("Choose from Gallery"),
            onTap: () {
              onGallerySourceTap();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
