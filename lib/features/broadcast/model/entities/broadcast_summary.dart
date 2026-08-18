import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/model/entities/_entities.dart';

/// Summary captured when ending broadcast (before scope disposal)
final class BroadcastSummary with EquatableMixin {
  const BroadcastSummary({
    required this.broadcast,
    required this.duration,
    required this.formattedDuration,
    required this.qualityScore,
    required this.totalParticipants,
    required this.allTimeParticipants,
    required this.recentParticipants,
  });

  final Broadcast broadcast;
  final Duration duration;
  final String formattedDuration;
  final double qualityScore;

  /// Current live participants at time of ending
  final int totalParticipants;

  /// Total number of unique participants throughout broadcast
  final int allTimeParticipants;

  /// Last 3 participants to join (for avatar stack)
  final List<Participant> recentParticipants;

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
