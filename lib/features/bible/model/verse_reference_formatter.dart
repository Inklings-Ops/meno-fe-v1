import 'package:meno/features/bible/model/entities/verse.dart';

/// Formats a list of verses into a human-readable reference string.
/// E.g., "Romans 1:1-3, 5"
abstract final class VerseReferenceFormatter {
  VerseReferenceFormatter._();

  static String format(List<Verse> selected) {
    if (selected.isEmpty) return '';

    // Sort to ensure ranges are correctly identified
    final verses = List<Verse>.from(selected)
      ..sort((a, b) => a.verse.compareTo(b.verse));

    final first = verses.first;
    final reference = '${first.bookName} ${first.chapter}:';

    final buffer = StringBuffer(reference);
    final numbers = verses.map((v) => v.verse).toList();

    for (var i = 0; i < numbers.length; i++) {
      final start = numbers[i];
      var end = start;

      // Find continuous range
      while (i + 1 < numbers.length && numbers[i + 1] == end + 1) {
        end = numbers[++i];
      }

      if (start == end) {
        buffer.write(start);
      } else {
        buffer.write('$start-$end');
      }

      if (i < numbers.length - 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}
