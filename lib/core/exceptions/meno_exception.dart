import 'package:equatable/equatable.dart';
import 'package:meno/core/infrastructure/meno_response.dart';

/// The base class for all logical errors in the app
final class MenoException with EquatableMixin implements Exception {
  const MenoException(this.message, [this.code]);

  factory MenoException.fromResponse(MenoResponse response) {
    // Validation Error (Field Map exists)
    if (response.fieldErrors != null && response.fieldErrors!.isNotEmpty) {
      return ValidationException(
        response.fieldErrors!,
        code: response.statusCode,
      );
    }

    // If statusCode is 401/403, we might want to flag it as unauthenticated
    final code = response.statusCode ?? 0;
    if (code == 401 || code == 403) {
      return Unauthenticated(
        response.message ?? 'Unauthenticated',
        response.statusCode,
      );
    }

    return MenoException(
      response.message ?? 'Unknown error',
      response.statusCode,
    );
  }

  final String message;
  final int? code;

  @override
  List<Object?> get props => [message, code];
}

final class Unauthenticated extends MenoException {
  const Unauthenticated([super.message = 'Unauthenticated', super.code]);
}

final class ValidationException extends MenoException {
  ValidationException(this.fieldErrors, {int? code})
    : super(_formatErrors(fieldErrors), code);

  final Map<String, dynamic> fieldErrors;

  static String _formatErrors(Map<String, dynamic> errors) {
    // Your existing nice formatting logic
    return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}

final class ServerException extends MenoException {
  const ServerException([
    super.message = 'Server error occurred.',
    super.code = 500,
  ]);
}

final class NetworkException extends MenoException {
  const NetworkException() : super('No internet connection.');
}

final class UnknownException extends MenoException {
  const UnknownException([super.message = 'An unknown error occurred.']);
}

final class TimeoutException extends MenoException {
  const TimeoutException() : super('Request timed out.');
}

final class PermissionsException extends MenoException {
  const PermissionsException([
    super.message = 'Error occurred while requesting this permission',
  ]);
}

final class StorageException extends MenoException {
  const StorageException([super.message = 'Storage error occurred.']);
}

sealed class SocketException extends MenoException {
  const SocketException([super.message = 'Socket error occurred.']);
}

/// Thrown when attempting to use socket while not connected
final class SocketNotConnectedException extends SocketException {
  const SocketNotConnectedException(super.message);
}

/// Thrown when socket operation times out
final class SocketTimeoutException extends SocketException {
  const SocketTimeoutException(super.message);
}
