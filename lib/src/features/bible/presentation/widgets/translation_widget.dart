import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class TranslationWidget extends HookWidget {
  const TranslationWidget({
    super.key,
    required this.translation,
    this.progress,
    this.onDownload,
    this.onCancel,
    this.onTap,
    this.isOffline = true,
    this.loading = false,
  });

  final Translation translation;
  final VoidCallback? onTap;
  final bool isOffline;
  final double? progress;
  final VoidCallback? onDownload;
  final VoidCallback? onCancel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final isSelected = context.select(
      (TranslationsCubit bloc) => bloc.state.selectedTranslation == translation,
    );
    final abbreviation = translation.abbreviation.toUpperCase();
    final isDownloading = useState(false);
    final bloc = context.read<TranslationsCubit>();
    final borderRadius = BorderRadius.circular(24);
    return InkWell(
      onTap: () {
        if (isOffline) {
          bloc.changeTranslation(translation);
        } else {
          isDownloading.value = !isDownloading.value;
          bloc.downloadTranslation(translation).whenComplete(() {
            isDownloading.value = false;
          });
        }
      },
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
            if (!isOffline)
              _DownloadButton(
                onDownload: onDownload!,
                progress: progress!,
                onCancel: onCancel!,
                loading: isDownloading.value,
              ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.progress,
    required this.onDownload,
    required this.onCancel,
    this.loading = false,
  });

  final double progress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
      child: loading
          ? _ProgressIndicator(progress: progress, onCancel: onCancel)
          : IconButton(
              iconSize: 24,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.download_outlined),
              onPressed: !loading ? onDownload : null,
            ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress, required this.onCancel});
  final double progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(value: progress, strokeCap: StrokeCap.round),
        IconButton(
          onPressed: onCancel,
          padding: EdgeInsets.zero,
          iconSize: 20,
          style: IconButton.styleFrom(foregroundColor: colors.error),
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }
}
