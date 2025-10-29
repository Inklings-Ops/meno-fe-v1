import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/value_objects/email.dart';

/// Converts between [Email] and [String].
final class EmailConverter implements JsonConverter<Email, String> {
  /// Instantiates a [EmailConverter].
  const EmailConverter();

  @override
  Email fromJson(String json) => Email(json);

  @override
  String toJson(Email object) => object.getOrCrash();
}
