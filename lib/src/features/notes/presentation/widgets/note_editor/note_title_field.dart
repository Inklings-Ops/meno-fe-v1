import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteTitleField extends HookWidget {
  const NoteTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final bloc = context.watch<NoteEditorBloc>();
    return BlocConsumer<NoteEditorBloc, NoteEditorState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        bloc.state.whenOrNull(
          loaded: (note) {
            if (note.title.isValid) {
              textController.text = note.title.getOr();
            } else {
              textController.text = '';
            }
          },
        );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => TextFormField(
        autofocus: true,
        style: MTextTheme.of(context)!.heading3Bold,
        controller: textController,
        textInputAction: TextInputAction.next,
        onChanged: (value) => bloc.add(NoteTitleChanged(NoteTitle(value))),
        validator: (_) => state.whenOrNull(
          loaded: (note) => context.validator(note.title.value),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: 'Enter Title',
          contentPadding: EdgeInsets.zero,
          hintStyle: MTextTheme.of(context)!.heading3Bold,
        ),
      ),
    );
  }
}
