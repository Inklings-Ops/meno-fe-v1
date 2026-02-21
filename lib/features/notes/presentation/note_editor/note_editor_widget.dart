import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno/features/notes/applications/note_editor_manager.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// The heart of the people will be opened to receive the
/// gospel to them through any available means (2 Thessalonians 3:1)

class NoteEditorWidget extends WatchingWidget {
  const NoteEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);

    final manager = di<NoteEditorManager>();

    final scrollController = createOnce<ScrollController>(ScrollController.new);

    final quillController = createOnce<QuillController>(QuillController.basic);

    final quillFocusNode = createOnce<FocusNode>(FocusNode.new);

    final quillChangeSub = createOnce<StreamSubscription<DocChange>>(() {
      void onQuillDocumentChanged(DocChange change) {
        if (change.change.isEmpty) return;
        final delta = jsonEncode(quillController.document.toDelta().toJson());
        manager.onContentChanged(delta);
      }

      return quillController.document.changes.listen(onQuillDocumentChanged);
    });

    void loadContentFromNote(Note note) {
      if (!note.content.isValid) return;
      try {
        final json = jsonDecode(note.content.getOrCrash()) as List<dynamic>;
        quillController.document = Document.fromJson(json);
      } catch (_) {
        // Malformed delta — leave editor empty.
      }
    }

    callOnce((_) {
      loadContentFromNote(manager.note.value);
      manager.note.listen((note, _) {
        // Only re-populate if note identity changed(new → existing transition).
        if (note.id == manager.note.value.id) return;
        loadContentFromNote(note);
      });
    });

    onDispose(quillChangeSub.cancel);

    // Watch save status to update AppBar indicator.
    final status = watchValue((NoteEditorManager m) => m.status);

    // Watch folder for folder tag row.
    final note = watchValue((NoteEditorManager m) => m.note);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        leadingWidth: 90,
        leading: const MNotesBackButton(title: 'Notes'),
        actions: [
          NoteEditorAutosaveWidget(status: status),
          // "Done" button when keyboard is up
          ListenableBuilder(
            listenable: quillFocusNode,
            builder: (context, _) {
              if (!quillFocusNode.hasFocus) return const SizedBox.shrink();
              return TextButton(
                onPressed: quillFocusNode.unfocus,
                child: MText(
                  'Done',
                  color: colors.primary,
                  style: textTheme.captionMedium,
                ),
              );
            },
          ),
          Spaces.horizontalLarge,
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: NoteTitleField(quillFocusNode: quillFocusNode),
                  ),
                ),
                if (note.folder != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: FolderTag(folder: note.folder!),
                    ),
                  ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: QuillEditor.basic(
                      controller: quillController,
                      focusNode: quillFocusNode,
                      scrollController: ScrollController(),
                      config: QuillEditorConfig(
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          NoteEditorToolbar(
            controller: quillController,
            quillFocus: quillFocusNode,
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: NoteEditorToolbar(controller: contentController),
    );
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
