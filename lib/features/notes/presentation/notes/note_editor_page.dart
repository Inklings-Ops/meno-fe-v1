import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteEditorPage extends WatchingWidget {
  const NoteEditorPage({required this.noteId, super.key});

  final String? noteId;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<NoteEditorManager>(() {
          return NoteEditorManager(
            noteId: noteId == null ? null : Id.fromString(noteId!),
            repository: di<INotesRepository>(),
          );
        }, onCreated: (instance) => instance.initialize.run());
      },
    );

    final note = watchValue((NoteEditorManager m) => m.note);

    final isLoading = watchValue(
      (NoteEditorManager m) => m.initialize.isRunning,
    );

    if (isLoading) {
      return const Scaffold(body: Center(child: MLoadingIndicator.box()));
    }

    return NoteEditorWidget(note: note);
  }
}
