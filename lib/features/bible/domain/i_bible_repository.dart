import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

abstract class IBibleRepository with Disposable {
  /// Whether the local Bible store is empty (no translation seeded yet).
  bool get isBibleEmpty;

  /// Seeds the KJV from the bundled asset on first launch.
  Future<void> initialize();

  /// All 66 books mapped to their chapter counts.
  Map<String, int> get books;

  /// Translations already downloaded and stored locally.
  List<Translation> get localTranslations;

  /// Translations available for download but not yet stored.
  List<Translation> get availableTranslations;

  /// Returns all verses for a given [book], [chapter], and [translation].
  List<Verse> getVerses({
    required String book,
    required int chapter,
    required String translation,
  });

  /// Returns a single [Verse], or null if not found.
  Verse? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  });

  /// Downloads and persists a translation by its abbreviation (e.g. `'niv'`).
  Future<Either<MenoException, Translation>> downloadTranslation(
    String abbreviation,
  );

  /// Cancels an in-progress download.
  void cancelDownload();

  /// Emits download progress as a percentage [0–100].
  Stream<int> get downloadProgress;
}
