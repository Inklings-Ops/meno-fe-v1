import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NewFolderActionButton extends StatelessWidget {
  const NewFolderActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return BlocBuilder<FoldersBloc, FoldersState>(
      builder: (context, state) {
        switch (state.status) {
          case FoldersStatus.failure:
          case FoldersStatus.initial:
          case FoldersStatus.loading:
            return const SizedBox();
          case FoldersStatus.loadingMore:
          case FoldersStatus.success:
            if (state.folders.isEmpty) return const SizedBox();
            return InkWell(
              onTap: () async {
                final bloc = context.read<FoldersBloc>();
                final fld = await router.push<Folder?>(Routes.folderFormModal);
                if (fld != null) return bloc.add(UpdateFolderList(fld));
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
        }
      },
    );
  }
}
