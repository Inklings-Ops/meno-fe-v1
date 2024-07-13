import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_exception.freezed.dart';

@freezed
class DiscoverException with _$DiscoverException {
  const factory DiscoverException.message(String message) = _Message;
  const factory DiscoverException.serverError() = _ServerError;
  const factory DiscoverException.networkError() = _NetworkError;
  const factory DiscoverException.timeOutError() = _TimeOutError;
}
