import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_form/note_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_list/note_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/empty_note_list_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/note_card.dart';
import 'package:meno_fe_v1/src/router/routes.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({
    super.key,
    this.onNoteTap,
    this.showAddButton = false,
  });

  final VoidCallback? onNoteTap;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NoteListBloc>();

    return BlocListener<NoteFormCubit, NoteFormState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () {},
          (either) => either.fold(
            (l) => null,
            (newNote) => bloc.add(NoteListEvent.updateNotesList(newNote)),
          ),
        );
      },
      child: BlocBuilder<NoteListBloc, NoteListState>(
        bloc: bloc,
        buildWhen: (p, c) => p != c,
        builder: (context, state) => state.when(
          failure: (_) => const NoteListFailureWidget(),
          loading: () => const MLoadingIndicator.box(),
          success: (notes) {
            if (notes.isEmpty) return const EmptyNoteListWidget();

            return ListView.separated(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: MCore.large).r,
              itemCount: notes.length,
              separatorBuilder: (context, index) => MCore.large.verticalSpace,
              itemBuilder: (context, index) => NoteCard(
                note: notes[index]!,
                showAddButton: showAddButton,
                onTap: () => _handleOnTapNote(context, note: notes[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  dynamic _handleOnTapNote(BuildContext context, {Note? note}) {
    if (onNoteTap != null) {
      return onNoteTap?.call();
    } else {
      return context.push(Routes.newNote, extra: {'note': note});
    }
  }
}

class NoteListFailureWidget extends StatelessWidget {
  const NoteListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      children: [
        72.verticalSpace,
        const MText(
          'An error occurred while retrieving the notes. Please, reload to try again?',
          style: MTextStyle.bodyRegular,
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        SizedBox(
          height: 32.h,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
            style: OutlinedButton.styleFrom(
              textStyle: MTextStyle.microMedium,
              foregroundColor: colors.onBackground,
              iconColor: colors.onBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8).r
              ),
              side: BorderSide(
                color: colors.outlineVariant3!,
                width: 1.50.r,
              ),
            ),
            onPressed: () => context
                .read<NoteListBloc>()
                .add(const NoteListEvent.getAllNotes()),
          ),
        )
      ],
    );
  }
}
