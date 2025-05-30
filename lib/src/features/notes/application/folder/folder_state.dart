part of 'folder_bloc.dart';

final class FolderState with EquatableMixin {
  const FolderState({
    required this.folder,
    this.notes = const <Note?>[],
    this.isLoadingNotes = false,
    this.exception,
  });

  final Folder folder;
  final List<Note?> notes;
  final bool isLoadingNotes;
  final NoteException? exception;

  @override
  List<Object?> get props => [folder, notes, isLoadingNotes, exception];
  
  FolderState copyWith({
    Folder? folder,
    List<Note?>? notes,
    bool? isLoadingNotes,
    NoteException? exception,
  }) {
    return FolderState(
      folder: folder ?? this.folder,
      notes: notes ?? this.notes,
      isLoadingNotes: isLoadingNotes ?? this.isLoadingNotes,
      exception: exception ?? this.exception,
    );
  }
}
