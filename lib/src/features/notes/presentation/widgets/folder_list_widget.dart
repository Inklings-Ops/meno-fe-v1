import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
class FolderListWidget extends StatelessWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FolderListBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<FolderFormCubit, FolderFormState>(
          listenWhen: (p, c) => p.option != c.option,
          listener: (context, state) {
            state.option.fold(
              () {},
              (either) => either.fold(
                (l) => null,
                (newFolder) => bloc.add(FolderListEvent.updateList(newFolder)),
              ),
            );
          },
        ),
        BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<FolderListBloc, FolderListState>(
        bloc: bloc,
        buildWhen: (p, c) => p != c,
        builder: (context, state) => state.when(
          failure: (_) => const FolderListFailureWidget(),
          loading: () => const MLoadingIndicator.box(),
          success: (folders) {
            if (folders.isEmpty) return const EmptyFolderListWidget();
            return ListView.separated(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: folders.length,
              separatorBuilder: (context, index) =>
                  Spaces.verticalLarge,
              itemBuilder: (context, i) {
                final folder = folders[i]!;
                return FolderListTile(
                  folder: folder,
                  onTap: () => context.push(Routes.folder, extra: folder),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
