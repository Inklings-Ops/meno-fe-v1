import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

enum BroadcastStatus { active, inactive }

class Broadcast with EquatableMixin {
  const Broadcast({
    required this.id,
    required this.title,
    required this.description,
    this.status = BroadcastStatus.inactive,
    this.broadcastToken,
    this.creatorId,
    this.creator,
    this.fullName,
    this.imageUrl,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.deleted,
    this.liveListeners,
    this.totalListeners,
    this.creatorFullName,
    this.creatorBio,
    this.creatorImageUrl,
    this.imageId,
    this.timeZone,
  });

  static Broadcast empty = Broadcast(
    id: ID.empty,
    title: SingleLineString.empty,
    description: MultiLineString.empty,
  );

  final ID id;
  final SingleLineString title;
  final MultiLineString description;
  final BroadcastStatus status;
  final String? broadcastToken;
  final ID? creatorId;
  final Participant? creator;
  final SingleLineString? fullName;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final dynamic deleted;
  final int? liveListeners;
  final int? totalListeners;
  final SingleLineString? creatorFullName;
  final MultiLineString? creatorBio;
  final String? creatorImageUrl;
  final String? imageId;
  final String? timeZone;

  Broadcast copyWith({
    ID? id,
    SingleLineString? title,
    MultiLineString? description,
    BroadcastStatus? status,
    String? broadcastToken,
    ID? creatorId,
    Participant? creator,
    SingleLineString? fullName,
    String? imageUrl,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    dynamic deleted,
    int? liveListeners,
    int? totalListeners,
    SingleLineString? creatorFullName,
    MultiLineString? creatorBio,
    String? creatorImageUrl,
    String? imageId,
    String? timeZone,
  }) {
    return Broadcast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      broadcastToken: broadcastToken ?? this.broadcastToken,
      creatorId: creatorId ?? this.creatorId,
      creator: creator ?? this.creator,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      liveListeners: liveListeners ?? this.liveListeners,
      totalListeners: totalListeners ?? this.totalListeners,
      creatorFullName: creatorFullName ?? this.creatorFullName,
      creatorBio: creatorBio ?? this.creatorBio,
      creatorImageUrl: creatorImageUrl ?? this.creatorImageUrl,
      imageId: imageId ?? this.imageId,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        broadcastToken,
        status,
        creatorId,
        creator,
        fullName,
        imageUrl,
        startTime,
        endTime,
        createdAt,
        deleted,
        liveListeners,
        totalListeners,
        creatorFullName,
        creatorBio,
        creatorImageUrl,
        imageId,
        timeZone,
      ];

  @override
  bool? get stringify => true;
}

extension BroadcastX on Broadcast {
  bool get isEmpty => this == Broadcast.empty;
  bool get isNotEmpty => this != Broadcast.empty;
}
