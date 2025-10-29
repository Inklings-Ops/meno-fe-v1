import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/value_objects/image_object.dart';

/// Converts between [ImageObject] and [String].
final class ImageObjectConverter
    implements JsonConverter<ImageObject, String?> {
  /// Instantiates a [ImageObjectConverter].
  const ImageObjectConverter();

  @override
  ImageObject fromJson(String? json) => ImageObject(json, ImageObjectType.url);

  @override
  String? toJson(ImageObject object) => object.getOrCrash();
}
