import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

abstract class IBibleRepository with Disposable {
  /// Whether the local Bible store is empty (no translation seeded yet).
  bool get isBibleEmpty;

  /// Seeds the KJV from the bundled asset on first launch.
  Future<void> initialize();

  /// Translations already downloaded and stored locally.
  List<Translation> get localTranslations;

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

  /// Returns the current download progress.
  int get currentProgress;

  /// Remote is the source of truth for `available`.
  /// Falls back to local hardcoded list where only KJV is available,
  /// so all others render as "Coming Soon" until the API is fixed.
  Future<List<Translation>> fetchAvailableTranslations();

  // ==========================================================================
  // METADATA  — pure in-memory, O(1), no async
  // ==========================================================================
  /// Ordered map of book index → canonical name (0 = Genesis).
  Map<int, String> get books;

  /// Book index → chapter count.
  Map<int, int> get chapterCounts;

  /// Chapter count for a single book. Convenience over [chapterCounts][bookId].
  int chapterCount(int bookId);

  /// Verse count for a specific chapter (1-based). Used by the verse picker
  /// to know its upper bound without hitting the DB.
  int verseCount(int bookId, int chapter);
}
