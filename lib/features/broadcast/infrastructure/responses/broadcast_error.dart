import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_error.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class BroadcastError extends Equatable {
  final String? title;
  final String? description;
  final String? startTime;
  final String? timeZone;
  final String? cohosts;
  final String? image;
  final String? mimetype;
  final String? size;

  const BroadcastError({
    this.title,
    this.description,
    this.startTime,
    this.timeZone,
    this.cohosts,
    this.image,
    this.mimetype,
    this.size,
  });

  factory BroadcastError.fromJson(Map<String, dynamic> json) =>
      _$BroadcastErrorFromJson(json);

  @override
  List<Object?> get props => [
        title,
        description,
        startTime,
        timeZone,
        cohosts,
        image,
        mimetype,
        size,
      ];

  Map<String, dynamic> toJson() => _$BroadcastErrorToJson(this);
}
