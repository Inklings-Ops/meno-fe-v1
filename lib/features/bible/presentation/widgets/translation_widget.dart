import 'package:flutter/material.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class TranslationWidget extends StatelessWidget {
  const TranslationWidget({
    required this.translation,
    super.key,
    this.isSelected = false,
    this.onTap,
    this.onDownload,
    this.downloadProgress,
    this.onCancelDownload,
  });

  final Translation translation;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final int? downloadProgress;
  final VoidCallback? onCancelDownload;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final borderRadius = BorderRadius.circular(24);

    // A translation tile is "actionable" only if it's downloaded OR available.
    final isDownloaded = translation.downloaded;
    final isAvailable = translation.available;
    final isDownloading = downloadProgress != null;

    return InkWell(
      onTap: isDownloaded ? onTap : null,
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
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  MText(
                    translation.abbreviation.toUpperCase(),
                    style: textTheme.bodyMedium,
                  ),
                  MText(translation.name, style: textTheme.microRegular),
                ],
              ),
            ),
            if (!isDownloaded) ...[
              if (isDownloading) ...[
                _DownloadProgress(
                  progress: downloadProgress!,
                  onCancel: onCancelDownload,
                ),
              ],
              if (isAvailable) ...[
                SizedBox.square(
                  dimension: 40,
                  child: IconButton(
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.download_outlined),
                    onPressed: onDownload,
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.outlineVariant2,
                  borderRadius: BorderRadius.circular(Insets.md),
                  border: Border.all(color: colors.primary),
                ),
                child: MText('Coming Soon', style: textTheme.captionMedium),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DownloadProgress extends StatelessWidget {
  const _DownloadProgress({required this.progress, this.onCancel});

  final int progress;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return SizedBox.square(
      dimension: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            strokeCap: StrokeCap.round,
            strokeWidth: 3,
          ),
          IconButton(
            onPressed: onCancel,
            padding: EdgeInsets.zero,
            iconSize: 16,
            style: IconButton.styleFrom(foregroundColor: colors.error),
            icon: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
