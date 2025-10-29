import 'dart:io';

import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno_domain/meno_domain.dart';

/// Image Value Object
final class ImageObject extends ValueObject<String?> {
  /// Factory constructor: Validates eagerly and creates the instance.
  factory ImageObject(String? value, ImageObjectType type) {
    final validateResult = _validateImage(value, type: type);
    return ImageObject._(validateResult, type);
  }

  const ImageObject._(super.value, this.type);

  /// Default class for empty Image
  static ImageObject empty = ImageObject('', ImageObjectType.url);

  /// Get the type of the image.
  /// Returns [ImageObjectType.file] if the image is a [File]
  /// Returns [ImageObjectType.url] if the image is a url
  final ImageObjectType type;

  /// The maximum allowed file size in bytes (10MB).
  static const int _maxSizeBytes = 10 * 1024 * 1024;

  static Either<ValueException<String>, String> _validateImage(
    String? value, {
    required ImageObjectType type,
  }) {
    // Image file can be empty or is optional
    if (value == null || value.isEmpty) return const Right('');

    if (type.isUrl) return Right(value);

    final file = File(value);

    // Check if file exists and is accessible
    if (!file.existsSync()) return const Left(FileNotFoundException());

    // Check file type (must be JPG or PNG)
    final fileExt = file.path.split('.').last.toLowerCase();
    if (fileExt != 'jpg' && fileExt != 'jpeg' && fileExt != 'png') {
      return Left(InvalidFileFormatException(value));
    }

    // Check file size (not more than 10MB)
    final filSize = file.lengthSync();
    if (filSize > _maxSizeBytes) return const Left(FileTooLargeException());

    return Right(value);
  }
}

/// Type of image to be loaded.
enum ImageObjectType {
  /// The [ImageObject] type is a [File]
  file,

  /// The [ImageObject] type is a url [String]
  url,
}

/// Extension for [ImageObjectType]
extension ImageObjectTypeX on ImageObjectType {
  /// Returns true if the [ImageObjectType] is a [File]
  bool get isFile => this == ImageObjectType.file;

  /// Returns true if the [ImageObjectType] is a url [String]
  bool get isUrl => this == ImageObjectType.url;
}
