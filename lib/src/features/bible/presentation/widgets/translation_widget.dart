import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class TranslationWidget extends HookWidget {
  const TranslationWidget({
    required this.translation,
    super.key,
    this.onDownload,
    this.onChange,
    this.isOffline = true,
  });

  final Translation translation;
  final VoidCallback? onChange;
  final VoidCallback? onDownload;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final abbreviation = translation.abbreviation;
    final isSelected = context.select<TranslationBloc, bool>(
      (bloc) => bloc.state.translation.abbreviation == abbreviation,
    );

    final borderRadius = BorderRadius.circular(24);

    return InkWell(
      onTap: isOffline ? onChange : () {},
      borderRadius: borderRadius,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: isSelected ? Border.all(color: colors.primary!) : null,
          color: isSelected ? colors.primaryContainer : colors.outlineVariant2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MText(
                    abbreviation.toUpperCase(),
                    style: textTheme.bodyMedium,
                  ),
                  MText(translation.name, style: textTheme.microRegular),
                ],
              ),
            ),
            if (!isOffline) _DownloadButton(translation: translation),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.translation});

  final Translation translation;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BibleDownloaderBloc>();
    final abbreviation = translation.abbreviation;
    return BlocBuilder<BibleDownloaderBloc, BibleDownloaderState>(
      buildWhen: (p, c) =>
          p.downloading != c.downloading ||
          p.progress != c.progress ||
          p.translation != c.translation,
      builder: (context, state) {
        final loading = state.downloading && state.translation == abbreviation;
        return SizedBox.square(
          dimension: 40,
          child: loading
              ? const _ProgressIndicator()
              : IconButton(
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () => bloc.add(DownloadBible(abbreviation)),
                ),
        );
      },
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<BibleDownloaderBloc>();
    return Stack(
      alignment: Alignment.center,
      children: [
        BlocBuilder<BibleDownloaderBloc, BibleDownloaderState>(
          builder: (context, state) => CircularProgressIndicator(
            value: state.progress.toDouble() / 100,
            strokeCap: StrokeCap.round,
          ),
        ),
        IconButton(
          onPressed: () => bloc.add(const CancelBibleDownload()),
          padding: EdgeInsets.zero,
          iconSize: 20,
          style: IconButton.styleFrom(foregroundColor: colors.error),
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }
}
