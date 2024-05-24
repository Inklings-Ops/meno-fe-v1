import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/translations/translations_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

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

    final isSelected = context.select(
      (TranslationsCubit bloc) => bloc.state.selectedTranslation == translation,
    );

    final abbreviation = translation.abbreviation.toUpperCase();

    final isDownloading = useState(false);

    final bloc = context.read<TranslationsCubit>();

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
      borderRadius: BorderRadius.circular(24).r,
      child: Container(
        height: 66.h,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24).r,
          border: isSelected ? Border.all(color: colors.primary!) : null,
          color: isSelected ? colors.primaryContainer : colors.outlineVariant2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MText(abbreviation, style: MTextStyle.bodyMedium),
                  MText(translation.name, style: MTextStyle.microRegular),
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
      dimension: 40.h,
      child: loading
          ? _ProgressIndicator(progress: progress, onCancel: onCancel)
          : IconButton(
              iconSize: 24.r,
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
        CircularProgressIndicator(
          value: progress,
          strokeCap: StrokeCap.round,
        ),
        IconButton(
          onPressed: onCancel,
          padding: EdgeInsets.zero,
          iconSize: 20.r,
          style: IconButton.styleFrom(foregroundColor: colors.error),
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }
}
