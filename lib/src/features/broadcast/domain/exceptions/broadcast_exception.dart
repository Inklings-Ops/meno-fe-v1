import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_exception.freezed.dart';

@freezed
class BroadcastException with _$BroadcastException {
  const factory BroadcastException.message(String message) =
      BroadcastErrorMessage;
  const factory BroadcastException.serverError() = BroadcastServerError;
  const factory BroadcastException.networkError() = BroadcastNetworkError;
  const factory BroadcastException.timeOutError() = BroadcastTimeOutError;
}

extension BroadcastExceptionX on Object {
  BroadcastException get toException {
    return BroadcastException.message(toString());
  }
}
