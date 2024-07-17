import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/application/notes/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder_list_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/note_list_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/note_widget.dart';

class NoteBodyWidget extends StatelessWidget {
  const NoteBodyWidget({super.key, required this.selectedIndex});
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final notesBloc = context.read<NotesBloc>();
    final foldersBloc = context.read<FolderListBloc>();

    return RefreshIndicator.adaptive(
      onRefresh: () async => switch (selectedIndex.value) {
        0 => notesBloc.add(const NotesEvent.getNotes()),
        1 => foldersBloc.add(const FolderListEvent.getAllFolders()),
        _ => null,
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: 1.sw,
              padding: const EdgeInsets.fromLTRB(0, 24, 0, MCore.small).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: NoteWidget(
                      onTap: () => selectedIndex.value = 0,
                      selected: selectedIndex.value == 0,
                    ),
                  ),
                  MCore.small.horizontalSpace,
                  Expanded(
                    child: FolderWidget(
                      onTap: () => selectedIndex.value = 1,
                      selected: selectedIndex.value == 1,
                    ),
                  )
                ],
              ),
            ),
            20.verticalSpace,
            switch (selectedIndex.value) {
              0 => const NoteListWidget(),
              1 => const FolderListWidget(),
              _ => const SizedBox(),
            },
          ],
        ),
      ),
    );
  }
}
