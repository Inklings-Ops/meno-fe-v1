import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno_fe_v1/meno.dart';

class NoteEditorToolbar extends StatelessWidget {
  const NoteEditorToolbar({required this.controller, super.key});
  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Card(
        color: MColorScheme.of(context).surfaceTint,
        shape: const RoundedRectangleBorder(borderRadius: Corners.circle),
        child: QuillToolbar.simple(
          controller: controller,
          configurations: const QuillSimpleToolbarConfigurations(
            showRedo: false,
            showUndo: false,
            showFontFamily: false,
            showFontSize: false,
            showStrikeThrough: false,
            showInlineCode: false,
            showSubscript: false,
            showSuperscript: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showClearFormat: false,
            showDividers: false,
            showHeaderStyle: false,
            showListCheck: false,
            showCodeBlock: false,
            showLink: false,
            showSearchButton: false,
            showQuote: false,
            showLeftAlignment: false,
            showRightAlignment: false,
            showClipboardCut: false,
            showClipboardCopy: false,
            showClipboardPaste: false,
            showCenterAlignment: false,
            showIndent: false,
          ),
        ),
      ),
    );
  }
}
