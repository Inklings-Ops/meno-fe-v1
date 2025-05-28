import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_broadcasts.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedBroadcasts<BroadcastDto> with EquatableMixin {
  const PaginatedBroadcasts({
    required this.broadcasts,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedBroadcasts.fromJson(
    Map<String, dynamic> json,
    BroadcastDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedBroadcastsFromJson(json, fromJsonT);

  final List<BroadcastDto?> broadcasts;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [broadcasts, totalItems, totalPages, currentPage];

  Map<String, dynamic> toJson(Object? Function(BroadcastDto value) toJsonT) =>
      _$PaginatedBroadcastsToJson(this, toJsonT);

  @override
  bool? get stringify => true;
}

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedParticipants<ParticipantDto> with EquatableMixin {
  const PaginatedParticipants({
    required this.participants,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedParticipants.fromJson(
    Map<String, dynamic> json,
    ParticipantDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedParticipantsFromJson(json, fromJsonT);

  @JsonKey(name: 'broadcastListeners')
  final List<ParticipantDto?> participants;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [
        participants,
        totalItems,
        totalPages,
        currentPage,
      ];

  Map<String, dynamic> toJson(Object? Function(ParticipantDto value) toJsonT) =>
      _$PaginatedParticipantsToJson(this, toJsonT);

  @override
  bool? get stringify => true;
}
