import 'package:json_annotation/json_annotation.dart';
import 'package:meno_domain/src/models/models.dart' show ParticipantRole;

/// A JsonConverter to handle case-insensitive deserialization
/// of ParticipantRole.
class ParticipantRoleConverter
    implements JsonConverter<ParticipantRole, String> {
  /// Creates a [ParticipantRoleConverter].
  const ParticipantRoleConverter();

  /// Deserializes a lowercase string from JSON to a [ParticipantRole] enum.
  @override
  ParticipantRole fromJson(String json) {
    // Find the enum value that matches the lowercase string.
    // Throws an error if no match is found, which is good for catching
    // unexpected server values.
    return ParticipantRole.values.byName(json.toLowerCase());
  }

  /// Serializes a [ParticipantRole] enum to a lowercase string for JSON.
  @override
  String toJson(ParticipantRole object) => object.name;
}
