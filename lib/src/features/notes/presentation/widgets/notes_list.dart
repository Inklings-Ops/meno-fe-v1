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
    this.hasReachedMax = false,
    this.scrollController,
    this.bottomWidget,
  });

  final List<Note?> notes;
  final bool showAddButton;
  final void Function(Note)? onNoteTap;
  final void Function(Note)? onOptionTap;
  final Note? selectedNote;

  final bool hasReachedMax;
  final ScrollController? scrollController;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notes.length + (bottomWidget != null ? 1 : 0),
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        if (index >= notes.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.md),
            child: bottomWidget,
          );
        }

        final note = notes[index];
        if (note == null) return const SizedBox.shrink();

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
