import 'package:diacritic/diacritic.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fw;
import 'package:string_similarity/string_similarity.dart';

String normalizeString(String s) => removeDiacritics(
  s.toLowerCase().trim(),
);

List<String> tokenizeString(String s) => normalizeString(s)
    .split(RegExp('[^a-z0-9]+'))
    .where(
      (t) => t.isNotEmpty,
    )
    .toList();

Iterable<String> trigrams(String s) sync* {
  final t = normalizeString(s);

  if (t.length < 3) {
    return;
  }

  for (var i = 0; i <= t.length - 3; i++) {
    yield t.substring(i, i + 3);
  }
}

bool sharesTrigram(String a, String b) {
  final qa = Set.of(trigrams(a));

  if (qa.isEmpty) {
    return false;
  }

  final qb = Set.of(trigrams(b));
  qa.intersection(qb);

  return qa.intersection(qb).isNotEmpty;
}

/// Compute a combined fuzzy score using both `fuzzywuzzy` & `string_similarity`
int getFuzzyScore(String query, String candidate) {
  final q = normalizeString(query);
  final c = normalizeString(candidate);

  /// Exact contains wins
  if (c.contains(q)) {
    return 100;
  }

  /// Avoid partial / tokenSet which over-match
  final global = fw.ratio(q, c);
  final sim = (StringSimilarity.compareTwoStrings(q, c) * 100).round();

  /// Best token-to-query score
  final tokenBest = tokenizeString(candidate)
      .map((t) => fw.ratio(q, t))
      .fold<int>(
        0,
        (mx, v) => v > mx ? v : mx,
      );

  return [global, sim, tokenBest].reduce(
    (a, b) => a > b ? a : b,
  );
}
