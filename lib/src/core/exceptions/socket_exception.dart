class SocketException implements Exception {
  const SocketException(this.message);
  final dynamic message;
}

final class SocketTimeoutException extends SocketException {
  const SocketTimeoutException([super.message = 'Socket event timed out']);
}

final class SocketValidationException extends SocketException {
  SocketValidationException(this.errors) : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

String _validationErrors(Map<String, dynamic> errors) {
  return errors.values.map((e) => e.toString()).join('\n');
}
