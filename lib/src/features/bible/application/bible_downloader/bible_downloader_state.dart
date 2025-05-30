part of 'bible_downloader_bloc.dart';

final class BibleDownloaderState with EquatableMixin {
  const BibleDownloaderState({
    this.progress = 0,
    this.downloading = false,
    this.option = const None(),
    this.translation,
  });

  final String? translation;

  final int progress;
  final bool downloading;
  final Option<Either<BibleException, Translation>> option;

  @override
  List<Object?> get props => [translation, progress, downloading, option];

  BibleDownloaderState copyWith({
    String? translation,
    int? progress,
    bool? downloading,
    Option<Either<BibleException, Translation>>? option,
  }) {
    return BibleDownloaderState(
      translation: translation ?? this.translation,
      progress: progress ?? this.progress,
      downloading: downloading ?? this.downloading,
      option: option ?? this.option,
    );
  }
}
