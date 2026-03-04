final class DtoHelpers {
  const DtoHelpers._();

  static void checkJsonValidity(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid JSON, expected Map<String, dynamic>',
      );
    }
  }
}
