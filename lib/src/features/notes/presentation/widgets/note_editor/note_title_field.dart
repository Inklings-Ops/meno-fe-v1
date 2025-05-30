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
        switch (state) {
          case NoteEditorLoadSuccess(:final note):
            if (note.title.isValid) {
              textController.text = note.title.getOrCrash();
            } else {
              textController.text = '';
            }
          default:
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => TextFormField(
        autofocus: true,
        style: MTextTheme.of(context).heading3Bold,
        controller: textController,
        textInputAction: TextInputAction.next,
        enabled: state is! NoteEditorSaveInProgress,
        onChanged: (value) => bloc.add(
          NoteEditorTitleChanged(SingleLineString(value)),
        ),
        validator: (_) => switch (state) {
          NoteEditorLoadSuccess(:final note) =>
            note.title.failureOrNull?.message,
          _ => null,
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: 'Enter Title',
          contentPadding: EdgeInsets.zero,
          hintStyle: MTextTheme.of(context).heading3Bold,
        ),
      ),
    );
  }
}
