import 'package:equatable/equatable.dart';

sealed class NoteException with EquatableMixin implements Exception {
  const NoteException(this.message);
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

final class NoteTimeoutException extends NoteException {
  const NoteTimeoutException([super.message = 'Request timed out']);
}

final class NoteUnknownException extends NoteException {
  const NoteUnknownException([super.message = 'Unknown exception']);
}

final class NoteServerException extends NoteException {
  const NoteServerException([super.message = 'Server exception']);
}

final class NoteNetworkException extends NoteException {
  const NoteNetworkException([super.message = 'Network exception']);
}

final class NoteNotFoundException extends NoteException {
  const NoteNotFoundException([super.message = 'Note not found']);
}

final class NoteExceptionWithMessage extends NoteException {
  const NoteExceptionWithMessage(super.message);
}

final class NoteValidationException extends NoteException {
  NoteValidationException(this.errors) : super(_validationErrors(errors));
  final Map<String, dynamic> errors;
}

/// Helper function to format validation errors nicely
String _validationErrors(Map<String, dynamic> errors) {
  return errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}

extension NoteExceptionX on Object {
  NoteException get toNoteException {
    return NoteExceptionWithMessage(toString());
  }
}
