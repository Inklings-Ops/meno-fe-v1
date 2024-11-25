import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteSearchBox extends StatelessWidget {
  const NoteSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final hasNoNotes = context.select<NotesBloc, bool>(
      (bloc) => bloc.state.maybeWhen(
        orElse: () => true,
        loadSuccess: (notes) => notes.isEmpty,
      ),
    );

    if (hasNoNotes) return const SizedBox(height: Insets.lg);

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          onChanged: (value) {},
          hintText: 'Search for note',
          hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Insets.md),
          ),
          leading: const Icon(MIcons.search, size: Insets.lg),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFC2C7D0)),
              borderRadius: Corners.sm,
            ),
          ),
        ),
      ),
    );
  }
}
