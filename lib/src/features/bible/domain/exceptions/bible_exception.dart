import 'package:freezed_annotation/freezed_annotation.dart';

part 'bible_exception.freezed.dart';

@freezed
class BibleException with _$BibleException {
  const factory BibleException.message(String message) = _Message;
  const factory BibleException.serverError() = _ServerError;
  const factory BibleException.unknownError() = _UnknownError;
  const factory BibleException.timeOutError() = _TimeOutError;
  const factory BibleException.networkError() = _NetworkError;
}
