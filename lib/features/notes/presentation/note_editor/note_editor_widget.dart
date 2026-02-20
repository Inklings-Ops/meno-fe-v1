import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteEditorWidget extends StatefulWidget {
  const NoteEditorWidget({required this.note, super.key});
  final Note note;

  @override
  State<NoteEditorWidget> createState() => _NoteEditorWidgetState();
}

class _NoteEditorWidgetState extends State<NoteEditorWidget> {
  late QuillController contentController;
  late FocusNode quillFocusNode;
  late ScrollController scrollController;
  late QuillEditorConfig quillConfigs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        leadingWidth: 90,
        leading: const MNotesBackButton(title: 'Notes'),
        actions: const [NoteEditorAutosaveWidget(), Spaces.horizontalLarge],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spaces.verticalLarge,
            const NoteTitleField(),
            Spaces.verticalLarge,
            if (widget.note.folder != null) ...[
              FolderTag(folder: widget.note.folder!),
              Spaces.verticalLarge,
            ],
            Expanded(
              child: QuillEditor.basic(
                controller: contentController,
                focusNode: quillFocusNode,
                scrollController: scrollController,
                config: quillConfigs,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: NoteEditorToolbar(controller: contentController),
    );
  }

  @override
  void didChangeDependencies() {
    final content = widget.note.content;
    if (content.isValid) {
      final json = jsonDecode(content.getOrCrash()) as List<dynamic>;
      contentController.document = Document.fromJson(json);
    }

    final textTheme = MTextTheme.of(context);
    quillConfigs = QuillEditorConfig(
      padding: MediaQuery.viewInsetsOf(context),
      placeholder: 'Start writing...',
      expands: true,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
          textTheme.captionRegular,
          HorizontalSpacing.zero,
          VerticalSpacing.zero,
          VerticalSpacing.zero,
          null,
        ),
        placeHolder: DefaultTextBlockStyle(
          textTheme.captionRegular,
          HorizontalSpacing.zero,
          VerticalSpacing.zero,
          VerticalSpacing.zero,
          null,
        ),
      ),
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    contentController = QuillController.basic();
    quillFocusNode = FocusNode();
    scrollController = ScrollController();

    contentController.addListener(() {
      // final con = jsonEncode(contentController.document.toDelta().toJson());
      // context.read<NoteEditorBloc>().add(
      //   NoteEditorContentChanged(MultiLineString(con)),
      // );
    });
  }

  @override
  void dispose() {
    quillFocusNode.dispose();
    scrollController.dispose();
    contentController.dispose();
    super.dispose();
  }
}

class MNotesBackButton extends StatelessWidget {
  const MNotesBackButton({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Container(
      width: 56,
      height: 18,
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Row(
          children: [
            const Icon(MIcons.chevron_left, size: 16),
            Spaces.horizontalMicro,
            MText(title, style: textTheme.captionMedium),
          ],
        ),
      ),
    );
  }
}
