import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastSessionDto with EquatableMixin {
  const BroadcastSessionDto({
    required this.broadcastId,
    required this.broadcastToken,
    required this.timestamp,
    required this.creatorId,
  });

  factory BroadcastSessionDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON format');
    }

    return BroadcastSessionDto(
      broadcastId: json[_kBroadcastId] as String,
      broadcastToken: json[_kBroadcastToken] as String,
      timestamp: DateTime.parse(json[_kTimestamp] as String),
      creatorId: json[_kCreatorId] as String,
    );
  }

  final String broadcastId;
  final String broadcastToken;
  final DateTime timestamp;
  final String creatorId;

  static const String _kBroadcastId = 'broadcastId';
  static const String _kBroadcastToken = 'broadcastToken';
  static const String _kTimestamp = 'timestamp';
  static const String _kCreatorId = 'creatorId';

  Map<String, dynamic> toJson() => {
    _kBroadcastId: broadcastId,
    _kBroadcastToken: broadcastToken,
    _kTimestamp: timestamp.toIso8601String(),
    _kCreatorId: creatorId,
  };

  @override
  List<Object?> get props => [
    broadcastId,
    broadcastToken,
    timestamp,
    creatorId,
  ];
}

extension BroadcastSessionDtoX on BroadcastSessionDto {
  BroadcastSession get toDomain => BroadcastSession(
    broadcastId: Id.fromString(broadcastId),
    broadcastToken: broadcastToken,
    timestamp: timestamp,
    creatorId: Id.fromString(creatorId),
  );
}

extension BroadcastSessionX on BroadcastSession {
  BroadcastSessionDto get toDomain => BroadcastSessionDto(
    broadcastId: broadcastId.getOrCrash(),
    broadcastToken: broadcastToken,
    timestamp: timestamp,
    creatorId: creatorId.getOrCrash(),
  );
}
