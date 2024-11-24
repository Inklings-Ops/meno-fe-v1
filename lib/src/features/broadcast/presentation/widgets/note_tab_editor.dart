import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteTabEditor extends StatefulWidget {
  const NoteTabEditor({required this.note, super.key});

  final Note? note;

  @override
  State<NoteTabEditor> createState() => _NoteTabEditorState();
}

class _NoteTabEditorState extends State<NoteTabEditor> {
  // late TextEditingController titleController;
  late QuillController contentController;
  late FocusNode quillFocusNode;
  late ScrollController scrollController;
  late QuillEditorConfigurations quillConfigurations;

  @override
  void didChangeDependencies() {
    if (widget.note != null) {
      // titleController.text = widget.note!.title.getOr();

      final json = jsonDecode(widget.note!.content.getOr()) as List<dynamic>;
      contentController.document = Document.fromJson(json);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // titleController = TextEditingController();
    contentController = QuillController.basic();
    quillFocusNode = FocusNode();
    scrollController = ScrollController();
    quillConfigurations = QuillEditorConfigurations(
      controller: contentController,
      expands: true,
    );

    // titleController.addListener(() {
    //   final title = titleController.text;
    //   context.read<NoteEditorBloc>().add(NoteTitleChanged(NoteTitle(title)));
    // });

    contentController.addListener(() {
      final con = jsonEncode(contentController.document.toDelta().toJson());
      context.read<NoteEditorBloc>().add(NoteContentChanged(NoteContent(con)));
    });
  }

  @override
  void dispose() {
    quillFocusNode.dispose();
    scrollController.dispose();
    // titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MNotesBackButton(title: 'Notes'),
                NoteEditorAutosaveWidget(),
              ],
            ),
            Spaces.verticalLarge,
            const NoteTitleField(),
            Spaces.verticalLarge,
            Expanded(
              child: QuillEditor(
                focusNode: quillFocusNode,
                scrollController: scrollController,
                configurations: quillConfigurations,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NoteEditorToolbar(controller: contentController),
    );
  }
}
