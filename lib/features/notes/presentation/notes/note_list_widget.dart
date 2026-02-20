import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/entities/note.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteListWidget extends WatchingWidget {
  const NoteListWidget({
    super.key,
    this.showAddButton = false,
    this.isForLiveScaffold = false,
  });

  final bool showAddButton;

  /// Flag to set when the notes list is to be displayed from a Live
  /// Broadcast or Live Stream scaffold.
  final bool isForLiveScaffold;

  @override
  Widget build(BuildContext context) {
    final error = watchValue((NotesManager m) => m.error);
    final notes = watchValue((NotesManager m) => m.notes);
    final isLoading = watchValue((NotesManager m) => m.initialize.isRunning);

    const padding = EdgeInsets.all(Insets.lg);

    if (isLoading) return Skeletonizer(child: NotesList(notes: fakeNotes));

    if (error != null && notes.isEmpty) {
      return const Padding(padding: padding, child: NoteListFailureWidget());
    }

    if (error == null && notes.isEmpty) {
      return const Padding(padding: padding, child: EmptyNoteListWidget());
    }

    return NotesList(
      notes: notes,
      showAddButton: showAddButton,
      onNoteTap: (note) => _onNoteTap(context, note),
      onOptionTap: (note) => NoteCardOptionsModal.show(context, note: note),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    // final bloc = context.read<NotesBloc>();
    // Note? newN;
    //
    // if (widget.isForLiveScaffold) {
    //  newN = await router.push<Note?>(Routes.notesTabEditorFull, extra: note);
    // } else {
    //   newN = await router.push<Note?>(Routes.noteEditor, extra: note);
    // }
    //
    // if (newN != null) return bloc.add(NotesNoteReceived(newN));
  }
}
