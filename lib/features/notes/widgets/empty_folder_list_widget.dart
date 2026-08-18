import 'package:flutter/material.dart';
import 'package:meno/features/notes/widgets/new_folder_button.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmptyFolderListWidget extends StatelessWidget {
  const EmptyFolderListWidget({this.showAddButton = true, super.key});

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
            Assets.images.folder.image(height: 120, width: 160),
            MText(
              'Welcome! Organize your notes better through folders.',
              style: textTheme.bodyRegular,
              textAlign: .center,
            ),
            Spaces.verticalXLarge,
            if (showAddButton) const NewFolderButton.outlined(),
          ],
        ),
      ),
    );
  }
}
