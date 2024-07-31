import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class EmptyFolderPageWidget extends StatelessWidget {
  const EmptyFolderPageWidget({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      width: 266,
      height: 224,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120, width: 160),
          MText(
            'Let’s add some notes to this folder',
            style: textTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalXLarge,
          SizedBox(
            width: 155,
            height: 32,
            child: MSecondaryButton.icon(
              label: 'Add to this Folder',
              icon: const Icon(MIcons.plus),
              style: OutlinedButton.styleFrom(
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.small,
                ),
                side: BorderSide(
                  color: colors.outlineVariant3!,
                  width: 1.50,
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
            Spaces.verticalLarge,
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
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: list.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 6),
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
              Spaces.verticalLarge,
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
