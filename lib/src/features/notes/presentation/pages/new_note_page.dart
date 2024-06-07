import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_form/note_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';

import '../widgets/m_notes_back_button.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key, this.note});

  final Note? note;

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  QuillController controller = QuillController.basic();

  @override
  void didChangeDependencies() {
    if (widget.note != null) {
      final json = jsonDecode(widget.note!.content.get()!);
      controller.document = Document.fromJson(json);
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      context.read<NoteFormCubit>().init(widget.note!);
    }

    controller.addListener(() {
      final content = jsonEncode(controller.document.toDelta().toJson());
      context.read<NoteFormCubit>().contentChanged(content);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.watch<NoteFormCubit>();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (widget.note?.title == bloc.state.title ||
            widget.note?.content == bloc.state.content) {
          return;
        } else {
          context.read<NoteFormCubit>().onSubmit();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 42.h,
          leadingWidth: 90.w,
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
                    style: MTextStyle.captionMedium,
                  ),
                );
              },
            ),
            16.horizontalSpace,
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
          child: Column(
            children: [
              16.verticalSpace,
              _TitleField(initialNote: widget.note),
              MCore.large.verticalSpace,
              Expanded(
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: controller,
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
          height: 56.h,
          child: Card(
            color: colors.surfaceTint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MCore.circle).r,
            ),
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
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
                color: Colors.purple,
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
    return TextFormField(
      style: MTextStyle.heading3Bold,
      initialValue: initialNote?.title.get(),
      onChanged: context.watch<NoteFormCubit>().titleChanged,
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
