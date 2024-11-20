import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({required this.note, super.key});

  final Note? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController titleController;
  late QuillController contentController;
  late FocusNode quillFocusNode;
  late ScrollController scrollController;
  late QuillEditorConfigurations quillConfigurations;

  @override
  void didChangeDependencies() {
    if (widget.note != null) {
      titleController.text = widget.note!.title.getOr();

      final json = jsonDecode(widget.note!.content.getOr()) as List<dynamic>;
      contentController.document = Document.fromJson(json);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    contentController = QuillController.basic();
    quillFocusNode = FocusNode();
    scrollController = ScrollController();
    quillConfigurations = QuillEditorConfigurations(
      controller: contentController,
      expands: true,
    );

    titleController.addListener(() {
      final title = titleController.text;
      context.read<NoteEditorBloc>().add(NoteTitleChanged(NoteTitle(title)));
    });

    contentController.addListener(() {
      final con = jsonEncode(contentController.document.toDelta().toJson());
      context.read<NoteEditorBloc>().add(NoteContentChanged(NoteContent(con)));
    });
  }

  @override
  void dispose() {
    quillFocusNode.dispose();
    scrollController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

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
          children: [
            Spaces.verticalLarge,
            NoteTitleField(controller: titleController),
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
      floatingActionButton: NoteEditorToolbar(
        controller: contentController,
      ),
    );
  }
}
