import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder/folder_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_form/folder_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/create_folder_modal.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/m_notes_back_button.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/note_card.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../widgets/empty_folder_page_widget.dart';

class FolderPage extends HookWidget {
  const FolderPage({super.key, required this.folder});
  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final updatedFolder = useState(folder);
    final isNewFolder = updatedFolder.value != folder;

    final folderBloc = context.read<FolderCubit>();

    final numberOfNotes = (isNewFolder
            ? updatedFolder.value.numberOfNotes
            : folder.numberOfNotes) ??
        0;

    useEffect(() {
      context.read<FolderCubit>().getAllNotes();
      return null;
    }, const []);

    return RefreshIndicator(
      onRefresh: () => folderBloc.getAllNotes(),
      child: BlocListener<FolderFormCubit, FolderFormState>(
        listenWhen: (p, c) => p.option != c.option,
        listener: (context, state) {
          state.option.fold(
            () => null,
            (either) => either.fold(
              (_) => null,
              (newFolder) => updatedFolder.value = newFolder,
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 42.h,
            leadingWidth: 90.w,
            leading: const MNotesBackButton(title: 'Folders'),
            actions: [
              IconButton(
                icon: const Icon(MIcons.dots_horizontal),
                onPressed: () => context.showModal(
                  MModal(
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MModalListTile(
                          leading: const Icon(MIcons.edit_05),
                          title: 'Rename Folder',
                          onTap: () {
                            context.pop();
                            context.showModal(
                              CreateFolderModal(initialFolder: folder),
                              isScrollControlled: true,
                              useRootNavigator: true,
                            );
                          },
                        ),
                        MCore.small.verticalSpace,
                        MModalListTile(
                          leading: Icon(MIcons.trash, color: colors.error),
                          title: 'Delete',
                          titleColor: colors.error,
                          onTap: () => context.showDeleteFolderDialog(
                            updatedFolder.value,
                          ),
                        ),
                        MCore.large.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
            child: Column(
              children: [
                0.verticalSpace,
                FolderWidget(
                  value: '$numberOfNotes notes',
                  title: isNewFolder
                      ? updatedFolder.value.title.getOr()
                      : folder.title.getOr(),
                  titleStyle: MTextStyle.subheadingMedium,
                  valueStyle: MTextStyle.captionMedium,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  height: 88.h,
                ),
                24.verticalSpace,
                _NotesList(folder: folder)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.folder});
  final Folder folder;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        loading: () => const MLoadingIndicator.four(),
        success: (folder) {
          if (folder.notes == null || folder.notes?.isEmpty == true) {
            return EmptyFolderPageWidget(folder: folder);
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, i) => MCore.large.verticalSpace,
            itemCount: folder.notes!.length,
            itemBuilder: (context, i) => NoteCard(
              note: folder.notes![i]!,
              folder: folder,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
