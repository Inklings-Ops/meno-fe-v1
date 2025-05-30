import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class EmptyFolderListWidget extends StatelessWidget {
  const EmptyFolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Center(
      child: SizedBox(
        width: 266,
        child: Column(
          children: [
            Assets.images.folder.image(height: 120, width: 160),
            MText(
              'Welcome! Organize your notes better through folders.',
              style: textTheme.bodyRegular,
              textAlign: TextAlign.center,
            ),
            Spaces.verticalXLarge,
            const _CreateNewFolderButton(),
          ],
        ),
      ),
    );
  }
}

class _CreateNewFolderButton extends StatelessWidget {
  const _CreateNewFolderButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      width: 160,
      height: 32,
      child: MSecondaryButton.icon(
        label: 'Create New Folder',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: textTheme.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
          side: BorderSide(
            color: colors.outlineVariant3,
            width: 1.50,
          ),
        ),
        onPressed: () async {
          final bloc = context.read<FoldersBloc>();
          final newFolder = await router.push<Folder?>(Routes.folderFormModal);
          if (newFolder != null) {
            return bloc.add(FoldersUpdateFoldersRequested(newFolder));
          }
        },
      ),
    );
  }
}
