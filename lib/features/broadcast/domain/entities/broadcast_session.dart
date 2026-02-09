import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastSession with EquatableMixin {
  const BroadcastSession({
    required this.broadcastId,
    required this.broadcastToken,
    required this.creatorId,
  });

  factory BroadcastSession.fromBroadcast(Broadcast broadcast) {
    return BroadcastSession(
      broadcastId: broadcast.id,
      broadcastToken: broadcast.broadcastToken ?? '',
      creatorId: broadcast.creator?.id ?? broadcast.creatorId ?? Id.empty,
    );
  }

  final Id broadcastId;
  final String broadcastToken;
  final Id creatorId;

  bool get isValid =>
      broadcastId.isValid && broadcastToken.isNotEmpty && creatorId.isValid;

  @override
  List<Object?> get props => [broadcastId, broadcastToken, creatorId];
}
