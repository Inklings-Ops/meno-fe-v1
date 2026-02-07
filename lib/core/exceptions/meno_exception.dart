import 'package:equatable/equatable.dart';

/// The base class for all logical errors in the app
abstract class MenoException with EquatableMixin implements Exception {
  const MenoException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class NetworkException extends MenoException {
  const NetworkException() : super('No internet connection.');
}

final class ServerException extends MenoException {
  const ServerException([super.message = 'Server error occurred.']);
}

final class TimeoutException extends MenoException {
  const TimeoutException() : super('Request timed out.');
}

final class ValidationException extends MenoException {
  ValidationException(this.errors) : super(_formatErrors(errors));

  final Map<String, dynamic> errors;

  static String _formatErrors(Map<String, dynamic> errors) {
    // Your existing nice formatting logic
    return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}

final class UnknownException extends MenoException {
  const UnknownException([super.message = 'An unknown error occurred.']);
}
