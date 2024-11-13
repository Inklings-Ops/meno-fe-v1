import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_exception.freezed.dart';

@freezed
class BroadcastException with _$BroadcastException {
  const factory BroadcastException.message(String message) = _Message;
  const factory BroadcastException.serverError() = _ServerError;
  const factory BroadcastException.networkError() = _NetworkError;
  const factory BroadcastException.timeOutError() = _TimeOutError;
}

extension BroadcastExceptionX on Object {
  BroadcastException get toException {
    return BroadcastException.message(toString());
  }
}
