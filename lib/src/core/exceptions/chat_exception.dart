import 'package:equatable/equatable.dart';

sealed class ChatException with EquatableMixin implements Exception {
  const ChatException(this.message);
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

final class ChatTimeoutException extends ChatException {
  const ChatTimeoutException([super.message = 'Request timed out']);
}

final class ChatUnknownException extends ChatException {
  const ChatUnknownException([super.message = 'Unknown exception']);
}

final class ChatServerException extends ChatException {
  const ChatServerException([super.message = 'Server exception']);
}

final class ChatNetworkException extends ChatException {
  const ChatNetworkException([super.message = 'Network exception']);
}

final class ChatNoInternetException extends ChatException {
  const ChatNoInternetException([super.message = 'No internet connection']);
}

final class ChatNotFoundException extends ChatException {
  const ChatNotFoundException([super.message = 'Chat not found']);
}

final class ChatExceptionWithMessage extends ChatException {
  const ChatExceptionWithMessage(super.message);
}

final class ChatValidationException extends ChatException {
  ChatValidationException(this.errors) : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

/// Helper function to format validation errors nicely
String _validationErrors(Map<String, dynamic> errors) {
  return errors.values.map((e) => '$e').join('\n');
}
