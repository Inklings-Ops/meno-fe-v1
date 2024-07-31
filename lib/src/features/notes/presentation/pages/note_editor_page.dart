import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  QuillController controller = QuillController.basic();
  FocusNode quillFocusNode = FocusNode();
  final scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (widget.note != null) {
      final json = jsonDecode(widget.note!.content.getOr());
      controller.document = Document.fromJson(json);
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final content = jsonEncode(controller.document.toDelta().toJson());
      context.read<NoteFormCubit>().contentChanged(content);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return BlocListener<NoteFormCubit, NoteFormState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () {},
          (either) => either.fold(
            (exception) => context.showNoteError(exception),
            (_) => context.read<NotesBloc>().add(const NotesEvent.getNotes()),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 42,
          leadingWidth: 90,
          leading: const MNotesBackButton(title: 'Notes'),
          actions: [
            BlocBuilder<NoteFormCubit, NoteFormState>(
              buildWhen: (p, c) => p.loading != c.loading,
              builder: (context, state) {
                return InkWell(
                  onTap: state.loading
                      ? null
                      : context.read<NoteFormCubit>().onSubmit,
                  child: MText(
                    state.loading ? 'Saving...' : 'Done',
                    color: colors.primary,
                    style: textTheme.captionMedium,
                  ),
                );
              },
            ),
            Spaces.horizontalLarge,
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Spaces.verticalLarge,
              _TitleField(initialNote: widget.note),
              Spaces.verticalLarge,
              Expanded(
                child: QuillEditor(
                  focusNode: quillFocusNode,
                  scrollController: scrollController,
                  configurations: QuillEditorConfigurations(
                    controller: controller,
                    expands: true,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('de'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 56,
          child: Card(
            color: colors.surfaceTint,
            shape: const RoundedRectangleBorder(borderRadius: Corners.circle),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: controller,
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
                showAlignmentButtons: false,
                showLink: false,
                showSearchButton: false,
                showQuote: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showClipboardCut: false,
                showClipboardCopy: false,
                showClipboardPaste: false,
                showCenterAlignment: false,
                showDirection: false,
                showIndent: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({this.initialNote});
  final Note? initialNote;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return TextFormField(
      style: textTheme.heading3Bold,
      initialValue: initialNote?.title.getOr(),
      onChanged: context.watch<NoteFormCubit>().titleChanged,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: 'Enter Title',
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
