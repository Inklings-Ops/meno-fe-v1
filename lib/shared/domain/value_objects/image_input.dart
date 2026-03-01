import 'dart:io' show File;

import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/core.dart';
import 'package:meno/shared/domain/value_objects/image_origin.dart';

class ImageInput extends ValueObject<ImageOrigin?> {
  factory ImageInput.fromFile(File? file) {
    if (file == null) return ImageInput.empty;
    return ImageInput._(_validateFile(file));
  }

  factory ImageInput.fromUrl(String? url) {
    if (url == null || url.trim().isEmpty) return ImageInput.empty;
    return ImageInput._(_validateUrl(url));
  }

  const ImageInput._(super.value);

  static const ImageInput empty = ImageInput._(Right(null));

  static Either<ValueException<ImageOrigin?>, ImageOrigin?> _validateFile(
    File file,
  ) {
    final extension = file.path.split('.').last.toLowerCase();
    const allowed = ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'];

    if (!allowed.contains(extension)) {
      return Left(
        InvalidFileFormatException<ImageOrigin?>(
          LocalImage(file),
          msg: 'Invalid file format.',
        ),
      );
    }
    return Right(LocalImage(file));
  }

  static Either<ValueException<ImageOrigin?>, ImageOrigin?> _validateUrl(
    String url,
  ) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return Left(
        InvalidValueException<ImageOrigin?>(
          NetworkImage(url),
          msg: 'Invalid URL.',
        ),
      );
    }
    return Right(NetworkImage(url));
  }
}

extension ImageInputX on ImageInput {
  String? getUrl() => (getOrNull() as NetworkImage?)?.url;

  File? getFile() => (getOrNull() as LocalImage?)?.file;
}
