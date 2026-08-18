import 'package:meno/_core/_core.dart' as domain;
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/notes/model/dtos/_dtos.dart';
import 'package:meno/features/notes/model/entities/_entities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class NoteDto {
  NoteDto({
    required this.id,
    required this.title,
    required this.content,
    required this.ownerId,
    this.dbId = 0,
    this.pinned = false,
    this.createdAt,
    this.updatedAt,
    this.syncPending = false,
  });

  factory NoteDto.fromJson(dynamic json, String ownerId) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid Note JSON format');
    }

    final dto = NoteDto(
      id: json[_kId] as String,
      title: json[_kTitle] as String? ?? '',
      content: json[_kContent] as String? ?? '',
      ownerId: ownerId,
      pinned: json[_kPinned] as bool? ?? false,
      createdAt: json[_kCreatedAt] != null
          ? DateTime.tryParse(json[_kCreatedAt] as String)
          : null,
      updatedAt: json[_kUpdatedAt] != null
          ? DateTime.tryParse(json[_kUpdatedAt] as String)
          : null,
    );

    final folderJson = json[_kFolder];
    if (folderJson != null) {
      dto.folder.target = NoteFolderDto.fromJson(folderJson, ownerId: ownerId);
    }

    final creatorJson = json[_kCreator];
    if (creatorJson != null) {
      dto.creator.target = NoteCreatorDto.fromJson(creatorJson);
    }

    return dto;
  }

  @Id()
  int dbId;

  @Unique()
  final String id;

  /// The remote user id of the account that owns this note.
  /// Indexed for fast per-user filtering across a shared ObjectBox store.
  @Index()
  final String ownerId;

  final String title;

  final String content;

  final bool pinned;

  @Property(type: PropertyType.date)
  final DateTime? createdAt;

  @Property(type: PropertyType.date)
  final DateTime? updatedAt;

  bool syncPending;

  final folder = ToOne<NoteFolderDto>();

  final creator = ToOne<NoteCreatorDto>();

  static const _kId = 'id';
  static const _kTitle = 'title';
  static const _kContent = 'content';
  static const _kPinned = 'pinned';
  static const _kCreatedAt = 'createdAt';
  static const _kUpdatedAt = 'updatedAt';
  static const _kFolder = 'folder';
  static const _kCreator = 'creator';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kTitle: title,
    _kContent: content,
    _kPinned: pinned,
    _kCreatedAt: createdAt?.toIso8601String(),
    _kUpdatedAt: updatedAt?.toIso8601String(),
    if (folder.target != null) _kFolder: folder.target!.toJson(),
    if (creator.target != null) _kCreator: creator.target!.toJson(),
  };
}

extension NoteDtoX on NoteDto {
  Note get toDomain => Note(
    id: domain.Id.fromString(id),
    title: domain.SingleLineString(title),
    content: domain.MultiLineString(content),
    pinned: pinned,
    createdAt: createdAt,
    updatedAt: updatedAt,
    syncStatus: SyncStatus.fromBool(syncPending),
    folder: folder.target?.toDomain,
    creator: creator.target?.toDomain,
  );
}

extension NoteDomainX on Note {
  NoteDto toDto({required String ownerId, bool pending = false}) {
    final dto = NoteDto(
      id: id.getOrCrash(),
      ownerId: ownerId,
      title: title.getOrCrash(),
      content: content.getOrCrash(),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncPending: pending,
    );

    if (folder != null) dto.folder.target = folder!.toDto(ownerId: ownerId);
    if (creator != null) dto.creator.target = creator!.toDto;

    return dto;
  }
}
