import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/note_editor_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteTitleField extends WatchingWidget {
  const NoteTitleField({required this.quillFocusNode, super.key});

  final FocusNode quillFocusNode;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final manager = di<NoteEditorManager>();
    final isEdit = watchValue((NoteEditorManager m) => m.isEdit);

    final controller = createOnce(() {
      final currentTitle = manager.note.value.title.getOrElse((_) => '');
      return TextEditingController(text: currentTitle);
    });

    final status = watchValue((NoteEditorManager m) => m.status);

    return TextFormField(
      controller: controller,
      autofocus: !isEdit,
      style: textTheme.heading3Bold,
      textInputAction: .next,
      maxLines: null,
      keyboardType: .multiline,
      enabled: !status.isSaving,
      onChanged: manager.onTitleChanged,
      onFieldSubmitted: (_) => quillFocusNode.requestFocus(),
      decoration: InputDecoration(
        border: .none,
        errorBorder: .none,
        enabledBorder: .none,
        focusedBorder: .none,
        disabledBorder: .none,
        focusedErrorBorder: .none,
        hintText: 'Enter Title',
        contentPadding: .zero,
        hintStyle: textTheme.heading3Bold.copyWith(color: Colors.grey.shade400),
      ),
    );
  }
}
