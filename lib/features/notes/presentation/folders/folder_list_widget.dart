import 'package:flutter/material.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final bloc = context.read<FoldersBloc>();
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.lg),
      child: EmptyFolderListWidget(),
      // child: RefreshIndicator(
      //   onRefresh: () async => bloc.add(const FoldersGetFoldersRequested()),
      //   child: BlocBuilder<FoldersBloc, FoldersState>(
      //     builder: (context, state) {
      //       switch (state.status) {
      //         case FoldersStatus.initial:
      //         case FoldersStatus.loading:
      //           return Skeletonizer(child: FolderList(folders: fakeFolders));
      //         case FoldersStatus.failure:
      //           return const FolderListFailureWidget();
      //         case FoldersStatus.loadingMore:
      //         case FoldersStatus.success:
      //           if (state.folders.isEmpty) return const EmptyFolderListWidget();
      //           return FolderList(folders: state.folders);
      //       }
      //     },
      //   ),
      // ),
    );
  }
}

// class FolderList extends StatelessWidget {
//   const FolderList({required this.folders, super.key});
//   final List<Folder?> folders;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       physics: const AlwaysScrollableScrollPhysics(),
//       itemCount: folders.length,
//       separatorBuilder: (context, index) => Spaces.verticalLarge,
//       itemBuilder: (context, index) => FolderListTile(
//         folder: folders[index]!,
//         onTap: () => router.push(Routes.folder, extra: folders[index]),
//       ),
//     );
//   }
// }
