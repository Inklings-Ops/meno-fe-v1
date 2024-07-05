import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/gen/assets.gen.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_list/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'empty_note_list_widget.dart';
import 'note_card.dart';
import 'note_list_widget.dart';

class EmptyFolderPageWidget extends StatelessWidget {
  const EmptyFolderPageWidget({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 266.w,
      height: 224.h,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120.h, width: 160.w),
          const MText(
            'Let’s add some notes to this folder',
            style: MTextStyle.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          SizedBox(
            width: 155.w,
            height: 32.h,
            child: MSecondaryButton.icon(
              label: 'Add to this Folder',
              icon: const Icon(MIcons.plus),
              style: OutlinedButton.styleFrom(
                textStyle: MTextStyle.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8).r,
                ),
                side: BorderSide(
                  color: colors.outlineVariant3!,
                  width: 1.50.r,
                ),
              ),
              onPressed: () => context.showModal(
                _AllNotesModal(folder: folder),
                isScrollControlled: true,
                useRootNavigator: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllNotesModal extends HookWidget {
  const _AllNotesModal({required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesBloc>();

    final selectedNote = useState<Note?>(null);

    return BlocListener<NotesBloc, NotesState>(
      listenWhen: (p, c) => p != c,
      listener: (context, state) {
        // state.whenOrNull(success: (notes) => context.pop());
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MCore.large.verticalSpace,
            Expanded(
              child: BlocBuilder<NotesBloc, NotesState>(
                bloc: bloc,
                buildWhen: (p, c) => p != c,
                builder: (context, state) {
                  if (state.isLoading) return const MLoadingIndicator.box();

                  if (!state.isLoading && state.exception != null) {
                    return const NoteListFailureWidget();
                  }

                  if (state.notes.isEmpty) return const EmptyNoteListWidget();

                  final list =
                      state.notes.where((e) => e?.folder == null).toList();

                  return ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: MCore.large).r,
                    itemCount: list.length,
                    separatorBuilder: (context, i) => 16.verticalSpace,
                    itemBuilder: (context, i) => NoteCard(
                      note: list[i]!,
                      showAddButton: true,
                      folder: folder,
                      selected: selectedNote.value?.uid == list[i]?.uid,
                      onTap: () {
                        if (selectedNote.value != null) {
                          selectedNote.value = null;
                        } else {
                          selectedNote.value = list[i];
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            if (selectedNote.value != null) ...[
              MCore.large.verticalSpace,
              MPrimaryButton(
                label: 'Done',
                loading: bloc.state.isLoading,
                onPressed: () => bloc.add(
                  NotesEvent.addToFolder(folder, selectedNote.value!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
