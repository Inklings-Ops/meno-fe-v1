import 'package:meno/_core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/model/_model.dart';

final class BroadcastSessionDto {
  const BroadcastSessionDto({
    required this.currentUserId,
    required this.broadcast,
    required this.timestamp,
  });

  factory BroadcastSessionDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<BroadcastDraftDto>();
    return BroadcastSessionDto(
      currentUserId: json[_kCurrentUserId] as String,
      broadcast: BroadcastDto.fromJson(json[_kBroadcast]),
      timestamp: DateTime.parse(json[_kTimestamp] as String),
    );
  }

  final String currentUserId;
  final BroadcastDto broadcast;
  final DateTime timestamp;

  static const String _kCurrentUserId = 'currentUserId';
  static const String _kBroadcast = 'broadcast';
  static const String _kTimestamp = 'timestamp';

  Map<String, dynamic> toJson() => {
    _kCurrentUserId: currentUserId,
    _kBroadcast: broadcast.toJson(),
    _kTimestamp: timestamp.toIso8601String(),
  };
}

extension BroadcastSessionDtoX on BroadcastSessionDto {
  BroadcastSession get toDomain => BroadcastSession(
    currentUserId: .fromString(currentUserId),
    broadcast: broadcast.toDomain,
    timestamp: timestamp,
  );
}

extension BroadcastSessionX on BroadcastSession {
  BroadcastSessionDto get toDto => BroadcastSessionDto(
    currentUserId: currentUserId.getOrCrash(),
    broadcast: broadcast.toDto,
    timestamp: timestamp,
  );
}
