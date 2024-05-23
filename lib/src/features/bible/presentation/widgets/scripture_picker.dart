import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/application/translations/translations_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'bible_books_modal.dart';
import 'bible_translations_modal.dart';

class ScripturePicker extends StatelessWidget {
  const ScripturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(top: MCore.large, bottom: MCore.small),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const _ScriptureReference(),
                MCore.small.horizontalSpace,
                const _ScriptureTranslation(),
              ],
            ),
          ),
          MCore.small.horizontalSpace,
          const _PreviousAndNextButton(),
        ],
      ),
    );
  }
}

class _ScriptureTranslation extends StatelessWidget {
  const _ScriptureTranslation();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslationsCubit, TranslationsState>(
      buildWhen: (p, c) => p.selectedTranslation != c.selectedTranslation,
      builder: (context, state) {
        final translation = state.selectedTranslation;
        return _Container(
          content: translation.abbreviation.toUpperCase(),
          onTap: () => context.showModal(
            const BibleTranslationsModal(),
            isScrollControlled: true,
          ),
        );
      },
    );
  }
}

class _ScriptureReference extends StatelessWidget {
  const _ScriptureReference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScripturePickerCubit, ScripturePickerState>(
      buildWhen: (p, c) => p.reference != c.reference,
      builder: (context, state) => _Container(
        content: state.reference,
        onTap: () => context.showModal(
          const BibleBooksModal(),
          isScrollControlled: true,
        ),
      ),
    );
  }
}

class _PreviousAndNextButton extends StatelessWidget {
  const _PreviousAndNextButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final bloc = context.watch<ScripturePickerCubit>();

    return Row(
      children: [
        SizedBox.square(
          dimension: 32.r,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_left),
            padding: EdgeInsets.zero,
            iconSize: 20.r,
            style: IconButton.styleFrom(
              backgroundColor: colors.outlineVariant2,
            ),
            onPressed: bloc.isPreviousEnabled ? bloc.previousChapter : null,
          ),
        ),
        13.horizontalSpace,
        SizedBox.square(
          dimension: 32.r,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_right),
            padding: EdgeInsets.zero,
            iconSize: 20.r,
            style: IconButton.styleFrom(
              backgroundColor: colors.outlineVariant2,
            ),
            onPressed: bloc.isNextEnabled ? bloc.nextChapter : null,
          ),
        ),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({required this.content, required this.onTap});

  final String content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32.h,
        constraints: BoxConstraints.loose(Size.fromHeight(32.h)),
        padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MCore.circle).r,
          color: colorScheme.outlineVariant2,
        ),
        child: MText(content, style: MTextStyle.captionMedium),
      ),
    );
  }
}
