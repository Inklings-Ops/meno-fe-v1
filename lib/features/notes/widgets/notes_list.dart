import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/features/notes/manager/notes_manager.dart';
import 'package:meno/features/notes/model/entities/note.dart';
import 'package:meno/features/notes/widgets/note_card.dart';
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
    this.physics,
    this.controller,
    this.primary,
    super.key,
  });

  final List<Note?> notes;
  final bool showAddButton;
  final void Function(Note)? onNoteTap;
  final void Function(Note)? onNoteLongPress;
  final void Function(Note)? onNoteOptionsTap;
  final List<Id> selectedNoteIds;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      controller: controller,
      primary: primary,
      itemCount: notes.length,
      padding: padding ?? const .all(16),
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

class NoteListFailureWidget extends StatelessWidget {
  const NoteListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Column(
      children: [
        const SizedBox(height: 72),
        MText(
          'An error occurred while retrieving the notes. Please, try again?',
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
        ),
        Spaces.verticalXLarge,
        SizedBox(
          height: 32,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
            style: OutlinedButton.styleFrom(
              textStyle: textTheme.microMedium,
              foregroundColor: colors.onBackground,
              iconColor: colors.onBackground,
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              side: BorderSide(color: colors.outlineVariant3, width: 1.50),
            ),
            onPressed: () => di<NotesManager>().initialize.run(),
          ),
        ),
      ],
    );
  }
}
