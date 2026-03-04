import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  const MediaService(this._picker);

  final ImagePicker _picker;

  Future<File?> getImage({required bool fromGallery}) async {
    final xFile = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }
}
