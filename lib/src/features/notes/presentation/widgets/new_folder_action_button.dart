import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NewFolderActionButton extends StatelessWidget {
  const NewFolderActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    return BlocBuilder<FoldersBloc, FoldersState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        loaded: (folders) {
          if (folders.isEmpty) return const SizedBox();
          return InkWell(
            onTap: () async {
              final bloc = context.read<FoldersBloc>();
              final folder = await router.push<Folder?>(Routes.folderFormModal);
              if (folder != null) return bloc.add(UpdateFolderList(folder));
            },
            child: Row(
              children: [
                Icon(MIcons.plus, size: 22, color: colors.primary),
                Spaces.horizontalMicro,
                MText(
                  'Add New Folder',
                  style: textTheme.captionMedium,
                  color: colors.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
