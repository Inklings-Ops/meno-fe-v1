import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class ScripturePicker extends StatelessWidget {
  const ScripturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: const Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _ScriptureReference(),
                Spaces.horizontalSmall,
                _ScriptureTranslation(),
              ],
            ),
          ),
          Spaces.horizontalSmall,
          _PreviousAndNextButton(),
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
          onTap: () => context.showModal<void>(
            BlocProvider.value(
              value: context.read<TranslationsCubit>(),
              child: const BibleTranslationsModal(),
            ),
            isScrollControlled: true,
            useRootNavigator: true,
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
        onTap: () => context.showModal<void>(
          BlocProvider.value(
            value: context.read<ScripturePickerCubit>(),
            child: const BibleBooksModal(),
          ),
          isScrollControlled: true,
          useRootNavigator: true,
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
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_left),
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: IconButton.styleFrom(
              backgroundColor: colors.outlineVariant2,
            ),
            onPressed: bloc.isPreviousEnabled ? bloc.previousChapter : null,
          ),
        ),
        const SizedBox(width: 13),
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_right),
            padding: EdgeInsets.zero,
            iconSize: 20,
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
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        constraints: BoxConstraints.loose(const Size.fromHeight(32)),
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Corners.circle,
          color: colors.outlineVariant2,
        ),
        child: MText(content, style: textTheme.captionMedium),
      ),
    );
  }
}
