import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/domain.dart';

final class EndedBroadcast with EquatableMixin {
  const EndedBroadcast({required this.details, required this.reason});

  final Broadcast details;
  final EndedBroadcastReason reason;

  @override
  List<Object?> get props => [details, reason];

  @override
  String toString() => 'EndedBroadcast(details: $details, reason: $reason)';
}

final class EndedBroadcastReason with EquatableMixin {
  const EndedBroadcastReason({required this.type, required this.message});

  final String type;
  final String message;

  @override
  List<Object?> get props => [type, message];

  @override
  String toString() => 'EndedBroadcastReason(type: $type, message: $message)';
}
