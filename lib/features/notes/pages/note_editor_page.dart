import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/manager/user_manager.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/services/_services.dart';
import 'package:meno/features/notes/widgets/note_editor_widget.dart';

class NoteEditorPage extends WatchingWidget {
  const NoteEditorPage({required this.noteIdStr, super.key});

  final String? noteIdStr;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<NoteEditorManager>(() {
          return NoteEditorManager(
            http: di<NotesHttpService>(),
            local: di<NotesLocalService>(),
            currentUserId: di<UserManager>().currentUserId.value,
            noteId: noteIdStr != null ? .fromString(noteIdStr!) : null,
          );
        }, onCreated: (instance) => instance.initialize.run());
      },
    );

    return const _Content();
  }
}

class _Content extends WatchingStatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with WidgetsBindingObserver {
  final _manager = di<NoteEditorManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState st) {
    // Covers: home button, task switcher, screen lock, app kill by OS.
    // ObjectBox write already happened optimistically in the repository,
    // but this ensures the latest draft is flushed before we lose focus.
    if (st == AppLifecycleState.paused || st == AppLifecycleState.detached) {
      _manager.saveNow();
    }
  }

  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop) return;
    if (_manager.status.value.isDirty) await _manager.saveNow();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
      child: const NoteEditorWidget(),
    );
  }
}
