import 'package:meno/_core/_core.dart' as core;
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/notes/model/dtos/note_dto.dart';
import 'package:meno/features/notes/model/entities/_entities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class NoteFolderDto {
  NoteFolderDto({
    required this.id,
    required this.title,
    required this.ownerId,
    this.dbId = 0,
    this.numberOfNotes = 0,
    this.pinned = false,
    this.createdAt,
    this.updatedAt,
    this.syncPending = false,
  });

  factory NoteFolderDto.fromJson(dynamic json, {required String ownerId}) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid NoteFolder JSON format');
    }

    return NoteFolderDto(
      id: json[_kId] as String,
      ownerId: ownerId,
      title: json[_kTitle] as String? ?? '',
      numberOfNotes: (json[_kNumberOfNotes] as int?) ?? 0,
      pinned: json[_kPinned] as bool? ?? false,
      createdAt: json[_kCreatedAt] != null
          ? DateTime.tryParse(json[_kCreatedAt] as String)
          : null,
      updatedAt: json[_kUpdatedAt] != null
          ? DateTime.tryParse(json[_kUpdatedAt] as String)
          : null,
    );
  }

  @Id()
  int dbId;

  @Unique()
  final String id;

  @Index()
  final String ownerId;

  final String title;

  final int numberOfNotes;

  final bool pinned;

  @Property(type: PropertyType.date)
  final DateTime? createdAt;

  @Property(type: PropertyType.date)
  final DateTime? updatedAt;

  bool syncPending;

  @Backlink('folder')
  final notes = ToMany<NoteDto>();

  static const String _kId = 'id';
  static const String _kTitle = 'title';
  static const String _kNumberOfNotes = 'numberOfNotes';
  static const String _kPinned = 'pinned';
  static const String _kCreatedAt = 'createdAt';
  static const String _kUpdatedAt = 'updatedAt';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kTitle: title,
    _kNumberOfNotes: numberOfNotes,
    _kPinned: pinned,
    _kCreatedAt: createdAt?.toIso8601String(),
    _kUpdatedAt: updatedAt?.toIso8601String(),
  };

  NoteFolderDto copyWith({
    String? ownerId,
    String? title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteFolderDto(
      id: id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      numberOfNotes: numberOfNotes ?? this.numberOfNotes,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension NoteFolderDtoX on NoteFolderDto {
  NoteFolder get toDomain => NoteFolder(
    id: core.Id.fromString(id),
    title: core.SingleLineString(title),
    numberOfNotes: numberOfNotes,
    pinned: pinned,
    createdAt: createdAt,
    syncStatus: SyncStatus.fromBool(syncPending),
  );

  NoteFolder toDomainWithNotes(List<Note> notes) => NoteFolder(
    id: core.Id.fromString(id),
    title: core.SingleLineString(title),
    numberOfNotes: numberOfNotes,
    pinned: pinned,
    createdAt: createdAt,
    syncStatus: SyncStatus.fromBool(syncPending),
    notes: notes,
  );
}

extension NoteFolderDomainX on NoteFolder {
  NoteFolderDto toDto({required String ownerId, bool pending = false}) {
    return NoteFolderDto(
      id: id.getOrCrash(),
      ownerId: ownerId,
      title: title.getOrCrash(),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
      syncPending: pending,
    );
  }
}
