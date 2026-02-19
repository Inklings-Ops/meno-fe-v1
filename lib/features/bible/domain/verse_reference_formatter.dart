import 'package:meno/features/bible/domain/domain.dart';

/// Pure, stateless domain service.
///
/// Converts a list of [Verse] objects into a canonical scripture reference
/// string and can parse that string back into individual verse numbers.
///
/// Supported output formats:
///   Single verse  → "Romans 1:5"
///   Range         → "Romans 1:1-5"
///   Gaps          → "Romans 1:1,3,5"
///   Mixed         → "Romans 1:1-3,5,7-9"
///   Full chapter  → "Genesis 1" (when verses covers every verse)
final class VerseReferenceFormatter {
  const VerseReferenceFormatter._();

  // =========================================================================
  // FORMAT
  // =========================================================================

  /// Formats [verses] — which must all belong to the same book + chapter —
  /// into a canonical reference string.
  ///
  /// [verses] need not be pre-sorted; this method sorts them internally.
  static String format(List<Verse> verses) {
    assert(verses.isNotEmpty, 'Cannot format an empty verse list');
    assert(
      verses.every((v) => v.bookName == verses.first.bookName),
      'All verses must belong to the same book',
    );
    assert(
      verses.every((v) => v.chapter == verses.first.chapter),
      'All verses must belong to the same chapter',
    );

    final book = verses.first.bookName;
    final chapter = verses.first.chapter;
    final nums = verses.map((v) => v.verse).toList()..sort();

    return '$book $chapter:${_formatNumbers(nums)}';
  }

  // =========================================================================
  // PARSE
  // =========================================================================

  /// Parses the verse-spec portion of a reference (the part after the colon).
  ///
  /// Example inputs: "1", "1-5", "1,3,5", "1-3,5,7-9"
  /// Returns a sorted list of individual verse numbers.
  static List<int> parseVerseSpec(String spec) {
    final result = <int>[];

    for (final part in spec.split(',')) {
      final trimmed = part.trim();
      if (trimmed.contains('-')) {
        final bounds = trimmed.split('-');
        final start = int.tryParse(bounds[0].trim());
        final end = int.tryParse(bounds[1].trim());
        if (start != null && end != null && end >= start) {
          result.addAll(List.generate(end - start + 1, (i) => start + i));
        }
      } else {
        final n = int.tryParse(trimmed);
        if (n != null) result.add(n);
      }
    }

    return result..sort();
  }

  // =========================================================================
  // PRIVATE
  // =========================================================================

  /// Converts a sorted list of integers into range-notation (e.g. "1-3,5,7-9").
  static String _formatNumbers(List<int> numbers) {
    if (numbers.isEmpty) return '';

    final buffer = StringBuffer();
    var rangeStart = numbers.first;
    var prev = numbers.first;

    void flush(int start, int end) {
      if (buffer.isNotEmpty) buffer.write(',');
      buffer.write(start == end ? '$start' : '$start-$end');
    }

    for (var i = 1; i < numbers.length; i++) {
      final current = numbers[i];
      if (current == prev + 1) {
        prev = current;
      } else {
        flush(rangeStart, prev);
        rangeStart = current;
        prev = current;
      }
    }
    flush(rangeStart, prev);

    return buffer.toString();
  }
}
