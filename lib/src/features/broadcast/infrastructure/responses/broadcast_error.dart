import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_error.freezed.dart';
part 'broadcast_error.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createFactory: false,
)
class BroadcastError with _$BroadcastError {
  factory BroadcastError({
    String? title,
    String? description,
    String? startTime,
    String? timeZone,
    String? cohosts,
    String? image,
    String? mimetype,
    String? size,
  }) = _BroadcastError;

  BroadcastError._();

  factory BroadcastError.fromJson(Map<String, dynamic> json) =>
      _$BroadcastErrorFromJson(json);

  List<String?> get props => [
        title,
        description,
        startTime,
        timeZone,
        cohosts,
        image,
        mimetype,
        size,
      ];

  bool get hasError {
    return [
      title,
      description,
      startTime,
      timeZone,
      cohosts,
      image,
      mimetype,
      size,
    ].any((prop) => prop != null);
  }
}
