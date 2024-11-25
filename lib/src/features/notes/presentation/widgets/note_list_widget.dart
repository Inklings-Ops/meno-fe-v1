import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({super.key, this.showAddButton = false});
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) => RefreshIndicator.adaptive(
          onRefresh: () async => bloc.add(const GetNotesRequested()),
          child: state.maybeWhen(
            orElse: () => Skeletonizer(child: NotesList(notes: fakeNotes)),
            failure: (failure) => const NoteListFailureWidget(),
            loadSuccess: (notes) {
              if (notes.isEmpty) return const EmptyNoteListWidget();
              return NotesList(notes: notes, showAddButton: showAddButton);
            },
          ),
        ),
      ),
    );
  }
}
