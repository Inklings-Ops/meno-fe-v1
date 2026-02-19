import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class TranslationWidget extends WatchingWidget {
  const TranslationWidget({
    required this.translation,
    super.key,
    this.isDownloaded = true,
    this.onSelect,
    this.onDownload,
  });

  final Translation translation;

  /// True when the translation is already available offline.
  final bool isDownloaded;

  /// Called when the user taps a downloaded translation to activate it.
  final VoidCallback? onSelect;

  /// Called when the user initiates a download.
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final currentTranslation = watchValue((BibleManager m) => m.translation);
    final downloadProgress = watchValue(
      (TranslationsManager m) => m.downloadProgress,
    );
    final downloadingAbbr = watchValue(
      (TranslationsManager m) => m.downloadingAbbreviation,
    );

    final abb = translation.abbreviation;
    final isSelected = currentTranslation == abb;
    final isThisDownloading = downloadingAbbr == abb;

    final borderRadius = BorderRadius.circular(24);

    return InkWell(
      onTap: isDownloaded ? onSelect : null,
      borderRadius: borderRadius,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: isSelected ? Border.all(color: colors.primary) : null,
          color: isSelected ? colors.primaryContainer : colors.outlineVariant2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(abb.toUpperCase(), style: textTheme.bodyMedium),
                  MText(translation.name, style: textTheme.microRegular),
                ],
              ),
            ),
            if (!isDownloaded)
              _DownloadButton(
                isDownloading: isThisDownloading,
                progress: isThisDownloading ? downloadProgress : null,
                onDownload: onDownload,
                onCancel: () => di<TranslationsManager>().cancelDownload.run(),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.isDownloading,
    this.progress,
    this.onDownload,
    this.onCancel,
  });

  final bool isDownloading;
  final int? progress;
  final VoidCallback? onDownload;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    if (!isDownloading) {
      return IconButton(
        icon: const Icon(Icons.download_outlined),
        iconSize: 24,
        padding: EdgeInsets.zero,
        onPressed: onDownload,
      );
    }

    return SizedBox.square(
      dimension: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (progress ?? 0) / 100.0,
            strokeCap: StrokeCap.round,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            iconSize: 20,
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(foregroundColor: colors.error),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
