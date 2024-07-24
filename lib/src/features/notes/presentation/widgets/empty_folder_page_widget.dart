import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class EmptyFolderPageWidget extends StatelessWidget {
  const EmptyFolderPageWidget({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 266.toScale,
      height: 224.toScale,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120.toScale, width: 160.toScale),
           MText(
            'Let’s add some notes to this folder',
            style: $styles.text.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.vSpace,
          SizedBox(
            width: 155.toScale,
            height: 32.toScale,
            child: MSecondaryButton.icon(
              label: 'Add to this Folder',
              icon: const Icon(MIcons.plus),
              style: OutlinedButton.styleFrom(
                textStyle: $styles.text.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: $styles.radius.small,
                ),
                side: BorderSide(
                  color: colors.outlineVariant3!,
                  width: 1.50.toScale,
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
            $styles.spaces.verticalLarge,
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
                    padding: const EdgeInsets.only(bottom: 16).radius,
                    itemCount: list.length,
                    separatorBuilder: (context, i) => 16.vSpace,
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
              $styles.spaces.verticalLarge,
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
