import 'package:equatable/equatable.dart';

sealed class BibleException with EquatableMixin implements Exception {
  const BibleException(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BibleExceptionWithMessage extends BibleException {
  const BibleExceptionWithMessage(super.message);
}

final class BibleServerException extends BibleException {
  const BibleServerException([super.message = 'Server authentication error.']);
}

final class BibleTimeoutException extends BibleException {
  const BibleTimeoutException([super.message = 'Request timed out. Try again']);
}

final class BibleNetworkException extends BibleException {
  const BibleNetworkException([super.message = 'No internet connection.']);
}

final class BibleUnknownException extends BibleException {
  const BibleUnknownException([super.message = 'Unknown error.']);
}
