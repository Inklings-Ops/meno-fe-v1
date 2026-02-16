import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/dtos/broadcast_dto.dart';
import 'package:meno/features/broadcast/infrastructure/dtos/participant_dto.dart';

final class BroadcastSummaryDto with EquatableMixin {
  const BroadcastSummaryDto({
    required this.broadcast,
    required this.duration,
    required this.formattedDuration,
    required this.qualityScore,
    required this.totalParticipants,
    required this.allTimeParticipants,
    required this.recentParticipants,
  });

  factory BroadcastSummaryDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid format');
    }

    return BroadcastSummaryDto(
      broadcast: BroadcastDto.fromJson(json[_kBroadcast]),
      duration: Duration(milliseconds: json[_kDuration] as int),
      formattedDuration: json[_kFormattedDuration] as String,
      qualityScore: json[_kQualityScore] as double,
      totalParticipants: json[_kTotalParticipants] as int,
      allTimeParticipants: json[_kAllTimeParticipants] as int,
      recentParticipants: json[_kRecentParticipants] != null
          ? (json[_kRecentParticipants] as List<dynamic>)
                .map(ParticipantDto.fromJson)
                .toList()
          : [],
    );
  }

  final BroadcastDto broadcast;
  final Duration duration;
  final String formattedDuration;
  final double qualityScore;
  final int totalParticipants;
  final int allTimeParticipants;
  final List<ParticipantDto> recentParticipants;

  static const String _kBroadcast = 'broadcast';
  static const String _kDuration = 'duration';
  static const String _kFormattedDuration = 'formattedDuration';
  static const String _kQualityScore = 'qualityScore';
  static const String _kTotalParticipants = 'totalParticipants';
  static const String _kAllTimeParticipants = 'allTimeParticipants';
  static const String _kRecentParticipants = 'recentParticipants';

  Map<String, dynamic> toJson() => {
    _kBroadcast: broadcast.toJson(),
    _kDuration: duration.inMilliseconds,
    _kFormattedDuration: formattedDuration,
    _kQualityScore: qualityScore,
    _kTotalParticipants: totalParticipants,
    _kAllTimeParticipants: allTimeParticipants,
    _kRecentParticipants: recentParticipants.map((p) => p.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    broadcast,
    duration,
    formattedDuration,
    qualityScore,
    totalParticipants,
    allTimeParticipants,
    recentParticipants,
  ];
}

extension BroadcastSummaryDtoX on BroadcastSummaryDto {
  BroadcastSummary get toDomain => BroadcastSummary(
    broadcast: broadcast.toDomain,
    duration: duration,
    formattedDuration: formattedDuration,
    qualityScore: qualityScore,
    totalParticipants: totalParticipants,
    allTimeParticipants: allTimeParticipants,
    recentParticipants: recentParticipants.map((p) => p.toDomain).toList(),
  );
}

extension BroadcastSummaryX on BroadcastSummary {
  BroadcastSummaryDto get toDto => BroadcastSummaryDto(
    broadcast: broadcast.toDto,
    duration: duration,
    formattedDuration: formattedDuration,
    qualityScore: qualityScore,
    totalParticipants: totalParticipants,
    allTimeParticipants: allTimeParticipants,
    recentParticipants: recentParticipants.map((p) => p.toDto).toList(),
  );
}
