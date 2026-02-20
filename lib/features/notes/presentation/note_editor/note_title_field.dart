import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteTitleField extends WatchingWidget {
  const NoteTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: textController,
      // enabled: state is! NoteEditorSaveInProgress,
      // onChanged: (value) {},
      // validator: (_) {},
      autofocus: true,
      style: MTextTheme.of(context).heading3Bold,
      textInputAction: TextInputAction.next,
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
    );
  }
}
