import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/application/notes/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/create_folder_modal.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../widgets/note_body_widget.dart';

class NotesPage extends HookWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    return MScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MHeader(
            title: 'My Notes',
            action: switch (selectedIndex.value) {
              0 => const _AddNewNoteActionButton(),
              1 => const _AddNewFolderActionButton(),
              _ => null,
            },
          ),
        ),
      ),
      body: NoteBodyWidget(selectedIndex: selectedIndex),
    );
  }
}

class _AddNewNoteActionButton extends StatelessWidget {
  const _AddNewNoteActionButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        if (state.notes.isEmpty) return const SizedBox();

        return InkWell(
          onTap: () => context.push(Routes.noteEditor),
          child: Row(
            children: [
              Icon(MIcons.plus, size: 22.r, color: colors.primary),
              MCore.micro.horizontalSpace,
              MText(
                'Add New Note',
                style: MTextStyle.captionMedium,
                color: colors.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddNewFolderActionButton extends StatelessWidget {
  const _AddNewFolderActionButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return BlocBuilder<FolderListBloc, FolderListState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        success: (folders) {
          if (folders.isEmpty) return const SizedBox();

          return InkWell(
            onTap: () => context.showModal(
              const CreateFolderModal(),
              isScrollControlled: true,
              useRootNavigator: true,
            ),
            child: Row(
              children: [
                Icon(MIcons.plus, size: 22.r, color: colors.primary),
                MCore.micro.horizontalSpace,
                MText(
                  'Add New Folder',
                  style: MTextStyle.captionMedium,
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
