import 'dart:io' show File;
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/_core/value_objects/value_exception.dart';
import 'package:meno/_core/value_objects/value_object.dart';

sealed class ImageOrigin with EquatableMixin {
  const ImageOrigin();
}

final class NetworkImageOrigin extends ImageOrigin {
  const NetworkImageOrigin(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

final class LocalImageOrigin extends ImageOrigin {
  const LocalImageOrigin(this.file);

  final File file;

  @override
  List<Object?> get props => [file];
}

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
          LocalImageOrigin(file),
          msg: 'Invalid file format.',
        ),
      );
    }
    return Right(LocalImageOrigin(file));
  }

  static Either<ValueException<ImageOrigin?>, ImageOrigin?> _validateUrl(
    String url,
  ) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return Left(
        InvalidValueException<ImageOrigin?>(
          NetworkImageOrigin(url),
          msg: 'Invalid URL.',
        ),
      );
    }
    return Right(NetworkImageOrigin(url));
  }
}

extension ImageInputX on ImageInput {
  String? getUrl() => (getOrNull() as NetworkImageOrigin?)?.url;

  File? getFile() => (getOrNull() as LocalImageOrigin?)?.file;
}
