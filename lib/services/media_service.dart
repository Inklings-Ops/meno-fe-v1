import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MediaService {
  final ImagePicker _picker;

  MediaService(this._picker);

  Future<XFile?> getImage({required bool fromGallery}) async {
    return await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );
  }
}
