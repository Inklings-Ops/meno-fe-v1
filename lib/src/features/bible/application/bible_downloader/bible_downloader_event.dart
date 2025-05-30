part of 'bible_downloader_bloc.dart';

sealed class BibleDownloaderEvent with EquatableMixin {
  const BibleDownloaderEvent();

  @override
  List<Object?> get props => [];
}

final class BibleDownloadRequested extends BibleDownloaderEvent {
  const BibleDownloadRequested(this.translation);
  final String translation;

  @override
  List<Object?> get props => [translation];
}

final class _UpdateDownloadProgress extends BibleDownloaderEvent {
  const _UpdateDownloadProgress(this.progress);
  final int progress;

  @override
  List<Object?> get props => [progress];
}

final class BibleCancelDownloadRequested extends BibleDownloaderEvent {
  const BibleCancelDownloadRequested();
}
