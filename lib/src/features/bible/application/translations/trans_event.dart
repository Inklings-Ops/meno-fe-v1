part of 'trans_bloc.dart';

@freezed
class TransEvent with _$TransEvent {
  const factory TransEvent.changeTranslation(
    Translation translation,
  ) = ChangeTranslation;

  const factory TransEvent.getTranslations() = GetTranslations;

  const factory TransEvent.downloadTranslation(
    Translation translation,
  ) = DownloadTranslation;

  const factory TransEvent.cancelDownload(
    Translation translation,
  ) = CancelTranslationDownload;

  const factory TransEvent.updateProgress(double progress) = _UpdateProgress;
}
