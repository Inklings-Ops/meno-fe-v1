import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Column(
      children: [
        const SizedBox(height: 72),
        MText(
          'An error occurred while retrieving the folders. Please, try again?',
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
            onPressed: () => di<FoldersManager>().initialize.run(),
          ),
        ),
      ],
    );
  }
}
