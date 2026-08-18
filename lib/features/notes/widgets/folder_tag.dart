import 'package:flutter/material.dart';
import 'package:meno/features/notes/model/entities/note_folder.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderTag extends StatelessWidget {
  const FolderTag({required this.folder, super.key});
  final NoteFolder folder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MTag(
          title: folder.title.getOrCrash(),
          style: MTextTheme.of(context).microMedium,
        ),
      ],
    );
  }
}
