import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    required this.notes,
    this.showAddButton = false,
    this.onNoteTap,
    this.onOptionTap,
    this.selectedNote,
    super.key,
  });

  final List<Note?> notes;
  final bool showAddButton;
  final void Function(Note)? onNoteTap;
  final void Function(Note)? onOptionTap;
  final Note? selectedNote;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final note = notes[index]!;
        return NoteCard(
          key: ValueKey(note.uid),
          note: note,
          showAddButton: showAddButton,
          selected: selectedNote?.uid == note.uid,
          onTap: () async => onNoteTap?.call(note),
          onOptionsTap: () => onOptionTap?.call(note),
        );
      },
    );
  }
}
