import 'package:flutter/material.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    required this.notes,
    this.showAddButton = false,
    this.onNoteTap,
    this.onNoteLongPress,
    this.onNoteOptionsTap,
    this.selectedNoteIds = const [],
    this.padding,
    super.key,
  });

  final List<Note?> notes;
  final bool showAddButton;
  final void Function(Note)? onNoteTap;
  final void Function(Note)? onNoteLongPress;
  final void Function(Note)? onNoteOptionsTap;
  final List<Id> selectedNoteIds;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: notes.length,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final note = notes[index];
        if (note == null) return const SizedBox.shrink();
        return NoteCard(
          key: ValueKey(note.id),
          note: note,
          showAddButton: showAddButton,
          selected: selectedNoteIds.contains(note.id),
          onTap: () => onNoteTap?.call(note),
          onLongPress: () => onNoteLongPress?.call(note),
          onOptionsTap: () => onNoteOptionsTap?.call(note),
        );
      },
    );
  }
}
