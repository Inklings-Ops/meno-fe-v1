import 'package:equatable/equatable.dart';

sealed class NotificationException with EquatableMixin implements Exception {
  const NotificationException(this.message);
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

final class NotificationTimeoutException extends NotificationException {
  const NotificationTimeoutException([super.message = 'Request timed out']);
}

final class NotificationUnknownException extends NotificationException {
  const NotificationUnknownException([super.message = 'Unknown exception']);
}

final class NotificationServerException extends NotificationException {
  const NotificationServerException([super.message = 'Server exception']);
}

final class NotificationNetworkException extends NotificationException {
  const NotificationNetworkException([super.message = 'Network exception']);
}

final class NotificationNotFoundException extends NotificationException {
  const NotificationNotFoundException([
    super.message = 'Notification not found',
  ]);
}

final class NotificationExceptionWithMessage extends NotificationException {
  const NotificationExceptionWithMessage(super.message);
}

final class NotificationValidationException extends NotificationException {
  NotificationValidationException(this.errors)
      : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

/// Helper function to format validation errors nicely
String _validationErrors(Map<String, dynamic> errors) {
  return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}

extension NotificationExceptionX on Object {
  NotificationException get toNotificationException {
    return NotificationExceptionWithMessage(toString());
  }
}
