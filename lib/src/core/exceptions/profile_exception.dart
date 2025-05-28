sealed class ProfileException implements Exception {
  const ProfileException(this.message);
  final String message;
}

final class ProfileServerException extends ProfileException {
  const ProfileServerException([super.message = 'Server error.']);
}

final class ProfileNetworkException extends ProfileException {
  const ProfileNetworkException([super.message = 'No internet connection.']);
}

final class ProfileTimeoutException extends ProfileException {
  const ProfileTimeoutException([super.message = 'The request timed out.']);
}

final class ProfileUnknownException extends ProfileException {
  const ProfileUnknownException([super.message = 'Unknown error.']);
}

final class NoProfileFoundException extends ProfileException {
  const NoProfileFoundException([super.message = 'No profile found.']);
}

final class ProfileTokenExpiredException extends ProfileException {
  const ProfileTokenExpiredException([
    super.message = 'Token has expired. Please log in again.',
  ]);
}

final class ProfileValidationException extends ProfileException {
  ProfileValidationException(this.errors) : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

final class ProfileExceptionWithMessage extends ProfileException {
  const ProfileExceptionWithMessage(super.message);
}

/// Helper function to format validation errors nicely
String _validationErrors(Map<String, dynamic> errors) {
  return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}
