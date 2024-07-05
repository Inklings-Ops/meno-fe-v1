import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/application/notes/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';

import 'empty_folder_list_widget.dart';
import 'folder_list_failure_widget.dart';
import 'folder_list_tile.dart';

class AddToFolderModal extends HookWidget {
  const AddToFolderModal({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final noteListBloc = context.watch<NotesBloc>();
    final folderListBloc = context.watch<FolderListBloc>();

    final selectedFolder = useState<Folder?>(null);

    return BlocListener<NotesBloc, NotesState>(
      bloc: noteListBloc,
      listenWhen: (p, c) => p != c,
      listener: (context, state) {
        // if (selectedFolder.value != null) {
        //   state.whenOrNull(
        //     success: (_) {
        //       folderListBloc.add(const FolderListEvent.getAllFolders());
        //       context.pop();
        //       context.pop();
        //     },
        //   );
        // }
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<FolderListBloc, FolderListState>(
                bloc: folderListBloc,
                buildWhen: (p, c) => p != c,
                builder: (context, state) => state.when(
                  failure: (_) => const FolderListFailureWidget(),
                  loading: () => const MLoadingIndicator.box(),
                  success: (folders) {
                    if (folders.isEmpty) {
                      return const EmptyFolderListWidget();
                    }

                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: MCore.large).r,
                      itemCount: folders.length,
                      separatorBuilder: (context, i) =>
                          MCore.large.verticalSpace,
                      itemBuilder: (context, i) {
                        final folder = folders[i]!;
                        return FolderListTile(
                          folder: folder,
                          selected: selectedFolder.value?.id == folder.id,
                          onTap: () => selectedFolder.value = folder,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (selectedFolder.value != null) ...[
              MCore.large.verticalSpace,
              MPrimaryButton(
                label: 'Done',
                loading: noteListBloc.state.isLoading,
                onPressed: () {
                  noteListBloc.add(
                    NotesEvent.addToFolder(selectedFolder.value!, note),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
