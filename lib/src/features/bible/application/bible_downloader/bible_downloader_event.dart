part of 'bible_downloader_bloc.dart';

@freezed
class BibleDownloaderEvent with _$BibleDownloaderEvent {
  const factory BibleDownloaderEvent.download(String translation) =
      DownloadBible;

  const factory BibleDownloaderEvent.cancel() = CancelBibleDownload;

  const factory BibleDownloaderEvent.updateProgress(int progress) =
      _UpdateProgress;
}
