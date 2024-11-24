import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

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
          orElse: () => const MLoadingIndicator.box(),
          failed: (_) => const FolderListFailureWidget(),
          loaded: (folders) {
            if (folders.isEmpty) return const EmptyFolderListWidget();
            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Insets.lg),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: folders.length,
              separatorBuilder: (context, index) => Spaces.verticalLarge,
              itemBuilder: (context, i) {
                final folder = folders[i];
                return FolderListTile(
                  folder: folder!,
                  onTap: () => router.push(Routes.folder, extra: folder),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
