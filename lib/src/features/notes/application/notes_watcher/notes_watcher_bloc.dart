// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'notes_watcher_event.dart';
part 'notes_watcher_state.dart';

class NotesWatcherBloc extends Bloc<NotesWatcherEvent, NotesWatcherState> {
  NotesWatcherBloc({required INoteFacade facade})
      : _facade = facade,
        super(const NotesWatcherInitial()) {
    on<NotesWatcherDeleteNoteRequested>(_onDeleteNote);
    on<NotesWatcherDeleteFolderRequested>(_onDeleteFolder);
    on<NotesWatcherAddNoteToFolderRequested>(_onAddNoteToFolder);
    on<NotesWatcherRemoveNoteToFolderRequested>(_onRemoveNoteFromFolder);
  }

  final INoteFacade _facade;

  Future<void> _onDeleteNote(
    NotesWatcherDeleteNoteRequested event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NotesWatcherLoadInProgress());
    final fOrU = await _facade.deleteNote(event.note.id);
    emit(
      fOrU.fold(
        NotesWatcherLoadFailed.new,
        (_) => NotesWatcherNoteDeleted(event.note),
      ),
    );
  }

  Future<void> _onDeleteFolder(
    NotesWatcherDeleteFolderRequested event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NotesWatcherLoadInProgress());
    final fOrU = await _facade.deleteFolder(event.folder.id);
    emit(
      fOrU.fold(
        NotesWatcherLoadFailed.new,
        (_) => NotesWatcherFolderDeleted(event.folder),
      ),
    );
  }

  Future<void> _onAddNoteToFolder(
    NotesWatcherAddNoteToFolderRequested event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NotesWatcherLoadInProgress());

    final result = await _facade.addNoteToFolder(
      noteId: event.note.id,
      folderId: event.folder.id,
    );

    emit(
      result.fold(
        NotesWatcherLoadFailed.new,
        (note) {
          final folderNotes = List<Note?>.from(event.folder.notes);
          final index = folderNotes.indexWhere((n) => n?.id == note.id);
          if (index == -1) {
            folderNotes.add(note);
          } else {
            folderNotes[index] = note;
          }
          final folder = event.folder.copyWith(
            notes: folderNotes,
            numberOfNotes: folderNotes.length,
          );
          return NotesWatcherNoteAddedToFolder(note, folder);
        },
      ),
    );
  }

  Future<void> _onRemoveNoteFromFolder(
    NotesWatcherRemoveNoteToFolderRequested event,
    Emitter<NotesWatcherState> emit,
  ) async {
    emit(const NotesWatcherLoadInProgress());

    final result = await _facade.removeNoteFromFolder(
      noteId: event.note.id,
      folderId: event.folder.id,
    );

    emit(
      result.fold(
        NotesWatcherLoadFailed.new,
        (_) {
          final folderNotes = List<Note?>.from(event.folder.notes);
          folderNotes.remove(event.note);

          final note = event.note.copyWith(folder: null);
          final folder = event.folder.copyWith(notes: folderNotes);
          return NotesWatcherNoteRemovedFromFolder(note, folder);
        },
      ),
    );
  }
}
