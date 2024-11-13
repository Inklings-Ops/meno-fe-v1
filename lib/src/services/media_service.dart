import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MediaService {
  MediaService(this._picker);
  final ImagePicker _picker;

  Future<XFile?> getImage({required bool fromGallery}) async {
    return _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );
  }
}
