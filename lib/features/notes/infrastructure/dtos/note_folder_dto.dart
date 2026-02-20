import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/dtos/note_dto.dart';
import 'package:meno/shared/domain/domain.dart' as domain;
import 'package:objectbox/objectbox.dart';

@Entity()
class NoteFolderDto {
  NoteFolderDto({
    required this.id,
    required this.title,
    this.dbId = 0,
    this.numberOfNotes = 0,
    this.pinned = false,
    this.createdAt,
    this.updatedAt,
    this.syncPending = false,
  });

  factory NoteFolderDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid NoteFolder JSON format');
    }

    return NoteFolderDto(
      id: json[_kId] as String,
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
}

extension NoteFolderDtoX on NoteFolderDto {
  NoteFolder get toDomain => NoteFolder(
    id: domain.Id.fromString(id),
    title: domain.SingleLineString(title),
    numberOfNotes: numberOfNotes,
    pinned: pinned,
    createdAt: createdAt,
    syncStatus: domain.SyncStatus.fromBool(syncPending),
  );

  NoteFolder toDomainWithNotes(List<Note> notes) => NoteFolder(
    id: domain.Id.fromString(id),
    title: domain.SingleLineString(title),
    numberOfNotes: numberOfNotes,
    pinned: pinned,
    createdAt: createdAt,
    syncStatus: domain.SyncStatus.fromBool(syncPending),
    notes: notes,
  );
}

extension NoteFolderDomainX on NoteFolder {
  NoteFolderDto get toDto => NoteFolderDto(
    id: id.getOrCrash(),
    title: title.getOrCrash(),
    numberOfNotes: numberOfNotes,
    pinned: pinned,
    createdAt: createdAt,
    syncPending: syncStatus == domain.SyncStatus.pending,
  );
}
