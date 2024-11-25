import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'notes_watcher_bloc.freezed.dart';
part 'notes_watcher_event.dart';
part 'notes_watcher_state.dart';

class NotesWatcherBloc extends Bloc<NotesWatcherEvent, NotesWatcherState> {
  NotesWatcherBloc({required INoteFacade facade})
      : _facade = facade,
        super(const NoteWatcherInitial()) {
    on<DeleteNote>(_onDeleteNote);
    on<AddNoteToFolder>(_onAddNoteToFolder);
    on<RemoveNoteFromFolder>(_onRemoveNoteFromFolder);
  }

  final INoteFacade _facade;

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NoteWatcherLoading());
    final result = await _facade.deleteNote(event.note.uid);
    emit(result.fold(NoteWatcherFailed.new, (_) => NoteDeleted(event.note)));
  }

  Future<void> _onAddNoteToFolder(
    AddNoteToFolder event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NoteWatcherLoading());

    final result = await _facade.addNoteToFolder(
      noteId: event.note.uid,
      folderId: event.folder.id,
    );

    emit(
      result.fold(
        NoteWatcherFailed.new,
        (note) {
          final folderNotes = List<Note?>.from(event.folder.notes ?? []);
          final index = folderNotes.indexWhere((n) => n?.uid == note.uid);
          if (index == -1) {
            folderNotes.add(note);
          } else {
            folderNotes[index] = note;
          }
          final folder = event.folder.copyWith(
            notes: folderNotes,
            numberOfNotes: folderNotes.length,
          );
          return NoteAddedToFolder(note: note, folder: folder);
        },
      ),
    );
  }

  Future<void> _onRemoveNoteFromFolder(
    RemoveNoteFromFolder event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NoteWatcherLoading());

    final result = await _facade.removeNoteFromFolder(
      noteId: event.note.uid,
      folderId: event.folder.id,
    );

    emit(
      result.fold(
        NoteWatcherFailed.new,
        (_) {
          final folderNotes = List<Note?>.from(event.folder.notes ?? []);
          folderNotes.remove(event.note);

          final note = event.note.copyWith(folder: null);
          final folder = event.folder.copyWith(notes: folderNotes);
          return NoteRemovedFromFolder(note: note, folder: folder);
        },
      ),
    );
  }
}
