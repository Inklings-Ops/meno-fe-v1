import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesPage extends HookWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return MScaffold(
      appBar: AppBar(
        title: const MHeader(
          title: 'My Notes',
          addTopMargin: true,
          padding: EdgeInsets.zero,
        ),
        actions: [
          switch (selectedIndex.value) {
            0 => const _AddNewNoteActionButton(),
            1 => const _AddNewFolderActionButton(),
            _ => const SizedBox(),
          },
          Spaces.horizontalLarge,
        ],
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
    final textTheme = MTextTheme.of(context)!;

    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        if (state.notes.isEmpty) return const SizedBox();

        return InkWell(
          onTap: () => context.push(Routes.noteEditor),
          child: Row(
            children: [
              Icon(MIcons.plus, size: 22, color: colors.primary),
              Spaces.horizontalMicro,
              MText(
                'Add New Note',
                style: textTheme.captionMedium,
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
    final textTheme = MTextTheme.of(context)!;

    return BlocBuilder<FolderListBloc, FolderListState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        success: (folders) {
          if (folders.isEmpty) return const SizedBox();

          return InkWell(
            onTap: () => context.showModal<void>(
              const CreateFolderModal(),
              isScrollControlled: true,
              useRootNavigator: true,
            ),
            child: Row(
              children: [
                Icon(MIcons.plus, size: 22, color: colors.primary),
                Spaces.horizontalMicro,
                MText(
                  'Add New Folder',
                  style: textTheme.captionMedium,
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
