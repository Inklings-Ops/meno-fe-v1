import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder_tag.dart';

class NoteEditorPage extends HookWidget {
  const NoteEditorPage({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final isSaved = useState<bool>(false);
    final bloc = context.read<NoteEditorBloc>();

    return BlocConsumer<NoteEditorBloc, NoteEditorState>(
      listenWhen: (p, c) => p is NoteSaveInProgress != c is NoteSaveInProgress,
      listener: (context, state) {
        state.whenOrNull(
          failure: context.showNoteError,
          saved: (newNote) {
            if (note.uid.isValid == false) {
              return router.pop(newNote);
            }
          },
        );
      },
      builder: (context, state) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (isSaved.value) return;
          
          isSaved.value = true;

          // Allow popping if no change is made to the note
          if ((state as NoteLoaded).note == note) return router.pop();

          // Allow popping is the note's title and content are empty, initially
          // or after editing.
          if (bloc.isNoteEmpty) return router.pop();

          // Save the note
          bloc.add(const NoteSaveRequested());

          // If the note exists, pop the route with the note as result after
          // editing
          if (bloc.isDoneEditingAndValid) return router.pop(state.note);
        },
        child: NoteEditor(note: note),
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({required this.note, super.key});
  final Note note;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late QuillController contentController;
  late FocusNode quillFocusNode;
  late ScrollController scrollController;
  late QuillEditorConfigurations quillConfigurations;

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

  @override
  void didChangeDependencies() {
    if (widget.note.content.isValid) {
      final json = jsonDecode(widget.note.content.getOr()) as List<dynamic>;
      contentController.document = Document.fromJson(json);
    }
    final textTheme = MTextTheme.of(context)!;
    quillConfigurations = QuillEditorConfigurations(
      controller: contentController,
      placeholder: 'Start writing...',
      expands: true,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
          textTheme.captionRegular!,
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        placeHolder: DefaultTextBlockStyle(
          textTheme.captionRegular!,
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
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
      final con = jsonEncode(contentController.document.toDelta().toJson());
      context.read<NoteEditorBloc>().add(NoteContentChanged(NoteContent(con)));
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
