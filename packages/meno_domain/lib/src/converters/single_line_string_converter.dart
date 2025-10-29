import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/value_objects/single_line_string.dart';

/// Converts between [SingleLineString] and [String].
final class SingleLineStringConverter
    implements JsonConverter<SingleLineString, String> {
  /// Instantiates a [SingleLineStringConverter].
  const SingleLineStringConverter();

  @override
  SingleLineString fromJson(String json) => SingleLineString(json);

  @override
  String toJson(SingleLineString object) => object.getOrCrash();
}
