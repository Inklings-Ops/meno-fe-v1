import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FoldersBloc>();
    return BlocBuilder<FoldersBloc, FoldersState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => RefreshIndicator.adaptive(
        onRefresh: () async => bloc.add(const GetAllFolders()),
        child: state.maybeWhen(
          orElse: () => Skeletonizer(child: FolderList(folders: fakeFolders)),
          failed: (_) => const FolderListFailureWidget(),
          loaded: (folders) {
            if (folders.isEmpty) return const EmptyFolderListWidget();
            return FolderList(folders: folders);
          },
        ),
      ),
    );
  }
}

class FolderList extends StatelessWidget {
  const FolderList({required this.folders, super.key});
  final List<Folder?> folders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(Insets.lg),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) => FolderListTile(
        folder: folders[index]!,
        onTap: () => router.push(Routes.folder, extra: folders[index]),
      ),
    );
  }
}
