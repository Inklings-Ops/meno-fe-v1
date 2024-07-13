import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_error.freezed.dart';
part 'discover_error.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createFactory: false,
)
class DiscoverError with _$DiscoverError {
  factory DiscoverError({
    String? id,
    String? status,
    String? include,
    String? keywords,
    String? creatorId,
    String? sortBy,
    String? orderBy,
    String? size,
    String? page,
    String? startTime,
    String? endTime,
  }) = _BroadcastError;

  DiscoverError._();

  factory DiscoverError.fromJson(Map<String, dynamic> json) =>
      _$DiscoverErrorFromJson(json);

  List<String?> get props => [
        id,
        status,
        include,
        keywords,
        creatorId,
        sortBy,
        orderBy,
        size,
        page,
        startTime,
        endTime,
      ];

  bool get hasError {
    return [
      id,
      status,
      include,
      keywords,
      creatorId,
      sortBy,
      orderBy,
      size,
      page,
      startTime,
      endTime,
    ].any((prop) => prop != null);
  }
}
