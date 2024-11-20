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

    final isSelected = context.select(
      (TransBloc bloc) => bloc.state.selectedTranslation == translation,
    );
    final abbreviation = translation.abbreviation.toUpperCase();

    final borderRadius = BorderRadius.circular(24);

    return InkWell(
      onTap: isOffline ? onChange : onDownload,
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
                  MText(abbreviation, style: textTheme.bodyMedium),
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
    final bloc = context.read<TransBloc>();
    return BlocBuilder<TransBloc, TransState>(
      buildWhen: (p, c) =>
          p.downloading != c.downloading ||
          p.downloadProgress != c.downloadProgress ||
          p.downloadingTranslation != c.downloadingTranslation,
      builder: (context, state) {
        final progress = state.downloadProgress;
        final loading = state.downloading;
        final downloadingTrans = state.downloadingTranslation?.abbreviation;
        final isTransDownloading = downloadingTrans == translation.abbreviation;
        final isDownloading = loading && isTransDownloading;
        return SizedBox.square(
          dimension: 40,
          child: isDownloading
              ? _ProgressIndicator(translation: translation, progress: progress)
              : IconButton(
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.download_outlined),
                  onPressed: !isDownloading
                      ? () => bloc.add(DownloadTranslation(translation))
                      : null,
                ),
        );
      },
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.progress,
    required this.translation,
  });

  final Translation translation;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<TransBloc>();
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(value: progress, strokeCap: StrokeCap.round),
        IconButton(
          onPressed: () => bloc.add(CancelTranslationDownload(translation)),
          padding: EdgeInsets.zero,
          iconSize: 20,
          style: IconButton.styleFrom(foregroundColor: colors.error),
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }
}
