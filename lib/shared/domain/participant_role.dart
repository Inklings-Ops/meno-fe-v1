/// Clean domain enum
enum ParticipantRole { host, cohost, listener }

// ============================================================================
// EXTENSION METHODS FOR SERIALIZATION
// ============================================================================

extension ParticipantRoleSerialization on ParticipantRole {
  /// Serialize to normal format (lowercase)
  String toNormal() => name;

  /// Serialize to upper case format (uppercase)
  String toUpper() => name.toUpperCase();

  /// Serialize based on context
  String serialize({required ParticipantRoleFormat format}) {
    return switch (format) {
      ParticipantRoleFormat.normal => toNormal(),
      ParticipantRoleFormat.upper => toUpper(),
    };
  }

  bool get isHost => this == ParticipantRole.host;
  bool get isCohost => this == ParticipantRole.cohost;
}

extension ParticipantRoleParsing on String {
  /// Parse from normal format (lowercase)
  ParticipantRole toRoleFromNormal() {
    return ParticipantRole.values.firstWhere(
      (role) => role.name == toLowerCase(),
      orElse: () => throw FormatException('Invalid role: $this'),
    );
  }

  /// Parse from upper case format (uppercase)
  ParticipantRole toRoleFromUpper() {
    return ParticipantRole.values.firstWhere(
      (role) => role.name.toUpperCase() == toUpperCase(),
      orElse: () => throw FormatException('Invalid role: $this'),
    );
  }

  /// Universal parser - auto-detects format
  ParticipantRole toRole() {
    final normalized = toLowerCase();
    return ParticipantRole.values.firstWhere(
      (role) => role.name == normalized,
      orElse: () => throw FormatException('Invalid role: $this'),
    );
  }
}

/// Serialization format enum
enum ParticipantRoleFormat { normal, upper }
