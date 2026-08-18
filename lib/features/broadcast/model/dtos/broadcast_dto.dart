import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/broadcast/model/_model.dart';

final class BroadcastDto with EquatableMixin {
  const BroadcastDto({
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
  });

  factory BroadcastDto.fromJson(dynamic json, [String? broadcastToken]) {
    if (json is! Map<String, dynamic>) throw FormatError<BroadcastDto>();
    return BroadcastDto(
      id: json[_kId] as String,
      title: json[_kTitle] as String,
      description: json[_kDescription] as String,
      status: json[_kStatus] != null
          ? BroadcastStatus.fromJson(json[_kStatus] as String)
          : BroadcastStatus.inactive,
      broadcastToken: broadcastToken ?? json[_kBroadcastToken] as String?,
      creatorId: json[_kCreatorId] as String?,
      creator: json[_kCreator] != null
          ? ParticipantDto.fromJson(json[_kCreator])
          : null,
      fullName: json[_kFullName] as String?,
      imageUrl: json[_kImageUrl] as String?,
      startTime: json[_kStartTime] != null
          ? DateTime.parse(json[_kStartTime] as String)
          : null,
      endTime: json[_kEndTime] != null
          ? DateTime.parse(json[_kEndTime] as String)
          : null,
      createdAt: json[_kCreatedAt] != null
          ? DateTime.parse(json[_kCreatedAt] as String)
          : null,
      deleted: json[_kDeleted] != null
          ? DateTime.parse(json[_kDeleted] as String)
          : null,
      liveListeners: (json[_kLiveListeners] as num?)?.toInt(),
      totalListeners: (json[_kTotalListeners] as num?)?.toInt(),
      creatorFullName: json[_kCreatorFullName] as String?,
      creatorBio: json[_kCreatorBio] as String?,
      creatorImageUrl: json[_kCreatorImageUrl] as String?,
    );
  }

  static const String _kId = 'id';
  static const String _kTitle = 'title';
  static const String _kDescription = 'description';
  static const String _kStatus = 'status';
  static const String _kBroadcastToken = 'broadcastToken';
  static const String _kCreatorId = 'creatorId';
  static const String _kCreator = 'creator';
  static const String _kFullName = 'fullName';
  static const String _kImageUrl = 'imageUrl';
  static const String _kStartTime = 'startTime';
  static const String _kEndTime = 'endTime';
  static const String _kCreatedAt = 'createdAt';
  static const String _kDeleted = 'deleted';
  static const String _kLiveListeners = 'liveListeners';
  static const String _kTotalListeners = 'totalListeners';
  static const String _kCreatorFullName = 'creatorFullName';
  static const String _kCreatorBio = 'creatorBio';
  static const String _kCreatorImageUrl = 'creatorImageUrl';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kTitle: title,
    _kDescription: description,
    _kStatus: status.value,
    _kBroadcastToken: broadcastToken,
    _kCreatorId: creatorId,
    _kCreator: creator?.toJson(),
    _kFullName: fullName,
    _kImageUrl: imageUrl,
    _kStartTime: startTime?.toIso8601String(),
    _kEndTime: endTime?.toIso8601String(),
    _kCreatedAt: createdAt?.toIso8601String(),
    _kDeleted: deleted?.toIso8601String(),
    _kLiveListeners: liveListeners,
    _kTotalListeners: totalListeners,
    _kCreatorFullName: creatorFullName,
    _kCreatorBio: creatorBio,
    _kCreatorImageUrl: creatorImageUrl,
  };

  final String id;
  final String title;
  final String description;
  final BroadcastStatus status;
  final String? broadcastToken;
  final String? creatorId;
  final ParticipantDto? creator;
  final String? fullName;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final DateTime? deleted;
  final int? liveListeners;
  final int? totalListeners;
  final String? creatorFullName;
  final String? creatorBio;
  final String? creatorImageUrl;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    broadcastToken,
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
  ];
}

extension BroadcastToDomainX on BroadcastDto {
  Broadcast get toDomain {
    return Broadcast(
      id: Id.fromString(id),
      title: SingleLineString(title),
      description: MultiLineString(description),
      status: status,
      broadcastToken: broadcastToken,
      creatorId: creatorId == null ? null : Id.fromString(creatorId!),
      creator: creator?.toDomain,
      fullName: fullName == null ? null : SingleLineString(fullName!),
      imageUrl: imageUrl,
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      deleted: deleted,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorFullName: creatorFullName != null
          ? SingleLineString(creatorFullName!)
          : null,
      creatorBio: creatorBio == null ? null : MultiLineString(creatorBio!),
      creatorImageUrl: creatorImageUrl,
    );
  }
}

extension BroadcastToDtoX on Broadcast {
  BroadcastDto get toDto {
    return BroadcastDto(
      id: id.getOrCrash(),
      title: title.getOrCrash(),
      description: description.getOrCrash(),
      status: status,
      broadcastToken: broadcastToken,
      creatorId: creatorId?.getOrNull(),
      creator: creator?.toDto,
      fullName: fullName?.getOrNull(),
      imageUrl: imageUrl,
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      deleted: deleted,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorFullName: creatorFullName?.getOrNull(),
      creatorBio: creatorBio?.getOrNull(),
      creatorImageUrl: creatorImageUrl,
    );
  }
}
