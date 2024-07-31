import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays a modal for selecting an image source.
///
/// The [MImageSourceModal] provides options to choose an image from the camera
/// or from the gallery. It takes callbacks for handling the selection of each
/// option.
///
/// Example usage:
/// ```dart
/// MImageSourceModal(
///   onCameraSourceTap: () {
///     // Handle camera source tap
///   },
///   onGallerySourceTap: () {
///     // Handle gallery source tap
///   },
/// );
/// ```
class MImageSourceModal extends StatelessWidget {
  /// Creates an instance of [MImageSourceModal].
  ///
  /// The [onCameraSourceTap] and [onGallerySourceTap] callbacks are required
  /// to handle the selection of the camera and gallery options, respectively.
  const MImageSourceModal({
    required this.onCameraSourceTap,
    required this.onGallerySourceTap,
    super.key,
  });

  /// Callback triggered when the camera source option is tapped.
  final VoidCallback onCameraSourceTap;

  /// Callback triggered when the gallery source option is tapped.
  final VoidCallback onGallerySourceTap;

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Choose Artwork',
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(MIcons.pause_circle),
            title: const MText('Choose from Camera'),
            onTap: () {
              onCameraSourceTap();
              Navigator.of(context).pop();
            },
          ),
          Spaces.verticalLarge,
          ListTile(
            leading: const Icon(MIcons.image),
            title: const MText('Choose from Gallery'),
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
