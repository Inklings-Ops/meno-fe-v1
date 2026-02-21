import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
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
          final effectiveNoteId = noteId != null
              ? Id.fromString(noteId!)
              : null;

          return NoteEditorManager(
            noteId: effectiveNoteId,
            repository: di<INotesRepository>(),
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

    // If nothing to save, pop immediately.
    if (!_manager.status.value.isDirty) {
      if (mounted) context.pop();
      return;
    }

    // Fire the save and let the optimistic local write complete before popping.
    // The remote part is fire-and-forget inside the repository.
    await _manager.saveNow();

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isInit = watchValue((NoteEditorManager m) => m.initialize.isRunning);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
      child: isInit
          ? const Scaffold(body: Center(child: MLoadingIndicator.box()))
          : const NoteEditorWidget(),
    );
  }
}
