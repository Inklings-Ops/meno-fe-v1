import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_exception.freezed.dart';

@freezed
class NoteException with _$NoteException {
  const factory NoteException.message(String message) = _Message;
  const factory NoteException.serverError() = _ServerError;
  const factory NoteException.unknownError() = _UnknownError;
  const factory NoteException.timeOutError() = _TimeOutError;
  const factory NoteException.networkError() = _NetworkError;
}
