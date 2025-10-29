import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/value_objects/multi_line_string.dart';

/// Converts between [MultiLineString] and [String].
final class MultiLineStringConverter
    implements JsonConverter<MultiLineString, String> {
  /// Instantiates a [MultiLineStringConverter].
  const MultiLineStringConverter();

  @override
  MultiLineString fromJson(String json) => MultiLineString(json);

  @override
  String toJson(MultiLineString object) => object.getOrCrash();
}
