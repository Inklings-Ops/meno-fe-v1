import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteBodyWidget extends StatelessWidget {
  const NoteBodyWidget({super.key, required this.selectedIndex});
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
              width: size.width,
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 8).radius,
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
                  $styles.spaces.horizontalSmall,
                  Expanded(
                    child: FolderWidget(
                      onTap: () => selectedIndex.value = 1,
                      selected: selectedIndex.value == 1,
                    ),
                  )
                ],
              ),
            ),
            20.vSpace,
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
