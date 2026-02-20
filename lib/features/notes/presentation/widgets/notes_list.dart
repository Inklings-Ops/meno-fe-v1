import 'package:flutter/material.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
        final note = notes[index];
        if (note == null) return const SizedBox.shrink();
        return NoteCard(
          key: ValueKey(note.id),
          note: note,
          showAddButton: showAddButton,
          selected: selectedNote?.id == note.id,
          onTap: () async => onNoteTap?.call(note),
          onOptionsTap: () => onOptionTap?.call(note),
        );
      },
    );
  }
}
