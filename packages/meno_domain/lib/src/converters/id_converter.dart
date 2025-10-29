import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/value_objects/id.dart';

/// Converts between [Id] and [String].
final class IdConverter implements JsonConverter<Id, String> {
  /// Instance of [IdConverter].
  const IdConverter();

  @override
  Id fromJson(String json) => Id.fromString(json);

  @override
  String toJson(Id object) => object.getOrCrash();
}
