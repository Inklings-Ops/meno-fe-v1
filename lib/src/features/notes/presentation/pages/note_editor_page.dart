import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorPage extends HookWidget {
  const NoteEditorPage({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final isSaved = useState<bool>(false);
    final bloc = context.read<NoteEditorBloc>();

    return BlocConsumer<NoteEditorBloc, NoteEditorState>(
      listenWhen: (p, c) => p is NoteSaveInProgress != c is NoteSaveInProgress,
      listener: (context, state) {
        state.whenOrNull(
          failure: context.showNoteError,
          saved: (newNote) {
            if (note.uid.isValid == false) {
              return router.pop(newNote);
            }
          },
        );
      },
      builder: (context, state) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (isSaved.value) return;
          
          isSaved.value = true;

          // Allow popping if no change is made to the note
          if ((state as NoteLoaded).note == note) return router.pop();

          // Allow popping is the note's title and content are empty, initially
          // or after editing.
          if (bloc.isNoteEmpty) return router.pop();

          // Save the note
          bloc.add(const NoteSaveRequested());

          // If the note exists, pop the route with the note as result after
          // editing
          if (bloc.isDoneEditingAndValid) return router.pop(state.note);
        },
        child: NoteEditorWidget(note: note),
      ),
    );
  }
}
