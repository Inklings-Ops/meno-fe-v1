import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/value_objects.dart';
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/broadcast/model/entities/_entities.dart';
import 'package:skeletonizer/skeletonizer.dart';

final class Broadcast with EquatableMixin {
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

  static Broadcast empty = const Broadcast(
    id: Id.empty,
    title: SingleLineString.empty,
    description: MultiLineString.empty,
  );

  final Id id;
  final SingleLineString title;
  final MultiLineString description;
  final BroadcastStatus status;
  final String? broadcastToken;
  final Id? creatorId;
  final Participant? creator;
  final SingleLineString? fullName;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final DateTime? deleted;
  final int? liveListeners;
  final int? totalListeners;
  final SingleLineString? creatorFullName;
  final MultiLineString? creatorBio;
  final String? creatorImageUrl;
  final String? imageId;
  final String? timeZone;

  Broadcast copyWith({
    Id? id,
    SingleLineString? title,
    MultiLineString? description,
    BroadcastStatus? status,
    String? broadcastToken,
    Id? creatorId,
    Participant? creator,
    SingleLineString? fullName,
    String? imageUrl,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    DateTime? deleted,
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

  Id get hostId => creator?.id ?? creatorId ?? Id.empty;

  SingleLineString get hostName =>
      fullName ??
      creator?.fullName ??
      creatorFullName ??
      SingleLineString.empty;

  bool get isActive =>
      status == .active && startTime != null && endTime == null;

  bool get isInActive =>
      status == .inactive && startTime != null && endTime != null;
}

extension BroadcastX on Broadcast {
  bool get isEmpty => this == Broadcast.empty;

  bool get isNotEmpty => this != Broadcast.empty;

  bool get isValid =>
      id.isValid &&
      broadcastToken != null &&
      (broadcastToken?.isNotEmpty ?? false);
}

final fakeBroadcasts = List.filled(
  3,
  Broadcast(
    id: Id.fromString('uniqueIdStr'),
    title: SingleLineString('title'),
    description: MultiLineString('longParagraph'),
    creator: fakeParticipants[0],
    creatorId: Id.fromString('name'),
    fullName: SingleLineString('fullName'),
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    createdAt: DateTime.now(),
    liveListeners: 100,
    totalListeners: 200,
  ),
);

final fakeLiveBroadcast = Broadcast(
  id: Id.fromString('87f4a2fb-0130-4d3e-aaed-a239829515a3'),
  title: SingleLineString('The Glory of the Lord'),
  description: MultiLineString(BoneMock.chars(244)),
  creator: Participant(
    id: Id.fromString('3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1'),
    fullName: SingleLineString('David Michael III'),
    bio: MultiLineString(BoneMock.chars(244)),
    imageUrl:
        'https://res.cloudinary.com/gson007/image/upload/v1698913558/nephz6baho5wgkg8wrz0.jpg',
  ),
  creatorId: Id.fromString('3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1'),
  fullName: SingleLineString('David Michael III'),
  startTime: DateTime.now(),
  createdAt: DateTime.parse('2026-03-02T21:19:31.979Z'),
  creatorFullName: SingleLineString('David Michael II'),
  creatorBio: MultiLineString(BoneMock.chars(244)),
  creatorImageUrl:
      'https://res.cloudinary.com/gson007/image/upload/v1698913558/nephz6baho5wgkg8wrz0.jpg',
  status: .active,
  broadcastToken: BoneMock.subtitle,
  liveListeners: 20380,
  totalListeners: 44600,
  imageUrl:
      'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEggruNurWPCNlOvEXA0pzSkR2eeihtnzRal_qXF0M25prd1V_Xu36aUdlD9bKaYo3b3Y7exXwxglHp_SfK6cu_93W8e5VzO7RzZzFmwwoQQ3Be_tr6N6G0wmjNs8vlYTaFi08jefOa5L4iu/s320/glory+of+God.jpg',
);
