import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteTitleField extends WatchingWidget {
  const NoteTitleField({required this.quillFocusNode, super.key});

  final FocusNode quillFocusNode;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final manager = di<NoteEditorManager>();

    final controller = createOnce(() {
      final currentTitle = manager.title.value;
      return TextEditingController(text: currentTitle.getOrElse((_) => ''));
    });

    final status = watchValue((NoteEditorManager m) => m.status);

    return TextFormField(
      controller: controller,
      autofocus: true,
      style: textTheme.heading3Bold,
      textInputAction: TextInputAction.next,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      enabled: !status.isSaving,
      onChanged: manager.onTitleChanged,
      onFieldSubmitted: (_) => quillFocusNode.requestFocus(),
      decoration: InputDecoration(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: 'Enter Title',
        contentPadding: EdgeInsets.zero,
        hintStyle: textTheme.heading3Bold.copyWith(color: Colors.grey.shade400),
      ),
    );
  }
}
