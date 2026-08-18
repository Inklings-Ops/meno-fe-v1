import 'package:flutter/material.dart';
import 'package:meno/features/notes/widgets/new_note_button.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmptyNoteListWidget extends StatelessWidget {
  const EmptyNoteListWidget({this.showAddButton = true, super.key});

  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Center(
      child: SizedBox(
        width: 266,
        child: Column(
          children: [
            if (showAddButton) Spaces.verticalXLarge,
            Assets.images.newFile.image(height: 120, width: 160),
            MText(
              'Welcome! Start writing down everything you take in.',
              style: textTheme.bodyRegular,
              textAlign: .center,
            ),
            Spaces.verticalXLarge,
            if (showAddButton) const NewNoteButton.outlined(),
          ],
        ),
      ),
    );
  }
}
