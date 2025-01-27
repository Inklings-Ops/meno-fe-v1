part of 'bible_downloader_bloc.dart';

@freezed
class BibleDownloaderState with _$BibleDownloaderState {
  const factory BibleDownloaderState({
    String? translation,
    @Default(0) int progress,
    @Default(false) bool downloading,
    @Default(None()) Option<Either<BibleException, Translation>> option,
  }) = _BibleDownloaderState;
}
