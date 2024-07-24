import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class EmptyFolderListWidget extends StatelessWidget {
  const EmptyFolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266.toScale,
      height: 224.toScale,
      child: Column(
        children: [
          Assets.images.folder.image(height: 120.toScale, width: 160.toScale),
          MText(
            'Welcome! Organize your notes better through folders.',
            style: $styles.text.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.vSpace,
          const _CreateNewFolderButton(),
        ],
      ),
    );
  }
}

class _CreateNewFolderButton extends StatelessWidget {
  const _CreateNewFolderButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 160.toScale,
      height: 32.toScale,
      child: MSecondaryButton.icon(
        label: 'Create New Folder',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: $styles.text.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: $styles.radius.small,
          ),
          side: BorderSide(
            color: colors.outlineVariant3!,
            width: 1.50.toScale,
          ),
        ),
        onPressed: () => context.showModal(
          const CreateFolderModal(),
          useRootNavigator: true,
          isScrollControlled: true,
        ),
      ),
    );
  }
}
