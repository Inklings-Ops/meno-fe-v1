import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/dtos/broadcast_dto.dart';

final class BroadcastSessionDto with EquatableMixin {
  const BroadcastSessionDto({required this.broadcast, required this.timestamp});

  factory BroadcastSessionDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON format');
    }

    return BroadcastSessionDto(
      broadcast: BroadcastDto.fromJson(json[_kBroadcast]),
      timestamp: DateTime.parse(json[_kTimestamp] as String),
    );
  }

  final BroadcastDto broadcast;
  final DateTime timestamp;

  static const String _kBroadcast = 'broadcast';
  static const String _kTimestamp = 'timestamp';

  Map<String, dynamic> toJson() => {
    _kBroadcast: broadcast.toJson(),
    _kTimestamp: timestamp.toIso8601String(),
  };

  @override
  List<Object?> get props => [broadcast, timestamp];
}

extension BroadcastSessionDtoX on BroadcastSessionDto {
  BroadcastSession get toDomain =>
      BroadcastSession(broadcast: broadcast.toDomain, timestamp: timestamp);
}

extension BroadcastSessionX on BroadcastSession {
  BroadcastSessionDto get toDto =>
      BroadcastSessionDto(broadcast: broadcast.toDto, timestamp: timestamp);
}
