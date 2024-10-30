import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.g.dart';

@riverpod
MediaService mediaService(MediaServiceRef ref) => di<MediaService>();

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
