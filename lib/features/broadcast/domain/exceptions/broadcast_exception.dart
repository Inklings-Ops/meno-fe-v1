import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_exception.freezed.dart';

@freezed
class BroadcastException with _$BroadcastException {
  const factory BroadcastException.message(String message) = _Message;
  const factory BroadcastException.serverError() = _ServerError;
}
