import 'package:equatable/equatable.dart';

sealed class BroadcastException with EquatableMixin implements Exception {
  const BroadcastException(this.message);
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

final class BroadcastTimeoutException extends BroadcastException {
  const BroadcastTimeoutException([super.message = 'Request timed out']);
}

final class BroadcastUnknownException extends BroadcastException {
  const BroadcastUnknownException([super.message = 'Unknown exception']);
}

final class BroadcastServerException extends BroadcastException {
  const BroadcastServerException([super.message = 'Server exception']);
}

final class BroadcastNetworkException extends BroadcastException {
  const BroadcastNetworkException([super.message = 'Network exception']);
}

final class BroadcastNotFoundException extends BroadcastException {
  const BroadcastNotFoundException([super.message = 'Broadcast not found']);
}

final class BroadcastExceptionWithMessage extends BroadcastException {
  const BroadcastExceptionWithMessage(super.message);
}

final class BroadcastValidationException extends BroadcastException {
  BroadcastValidationException(this.errors) : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

/// Helper function to format validation errors nicely
String _validationErrors(Map<String, dynamic> errors) {
  return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}

extension BroadcastExceptionX on Object {
  BroadcastException get toBroadcastException {
    return BroadcastExceptionWithMessage(toString());
  }
}
