import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/infrastructure/infrastructure.dart';

part 'ended_broadcast_data.g.dart';

@JsonSerializable()
class EndedBroadcastData with EquatableMixin {
  const EndedBroadcastData({
    required this.broadcastDetails,
    required this.reason,
  });

  factory EndedBroadcastData.fromJson(Map<String, dynamic> json) =>
      _$EndedBroadcastDataFromJson(json);

  Map<String, dynamic> toJson() => _$EndedBroadcastDataToJson(this);

  final BroadcastDto broadcastDetails;
  final EndedBroadcastReason reason;

  @override
  List<Object?> get props => [broadcastDetails, reason];
}

@JsonSerializable()
class EndedBroadcastReason with EquatableMixin {
  const EndedBroadcastReason({required this.type, required this.message});

  factory EndedBroadcastReason.fromJson(Map<String, dynamic> json) =>
      _$EndedBroadcastReasonFromJson(json);

  Map<String, dynamic> toJson() => _$EndedBroadcastReasonToJson(this);

  final String type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
