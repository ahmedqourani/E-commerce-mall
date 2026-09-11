import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A lexical guard against the app sliding back into being a food app.
///
/// The catalogue behind this app is a general, multi-category marketplace, so no
/// string the app supplies itself may name a single vertical. This test reads
/// every Dart file under `lib/`, strips comments, and fails if any food-specific
/// term survives in the code or copy.
///
/// Deliberately **not** banned, because they are real data rather than app copy:
///
/// * `grocery` / `groceries` and `kitchen` — genuine category names the API can
///   return. The rule is that the app must not *hardcode* a vertical, not that
///   the word may never appear; these arrive from the server, and banning them
///   would fight the API instead of the wording.
/// * `menu` — `Icons.menu` and Flutter's menu widgets are category-neutral. The
///   food-flavoured use of it, `Icons.restaurant_menu`, is caught by
///   `restaurant`.
/// * `delivery` / `shipping` — a mall ships things too.
///
/// Comments are stripped before matching so that a comment explaining what was
/// removed ("was a burger photo") does not trip the guard it documents.
void main() {
  final bannedTerms = <String>[
    'food', 'foods',
    'meal', 'meals',
    'restaurant', 'restaurants',
    'burger', 'burgers',
    'pizza', 'pizzas',
    'drink', 'drinks',
    'cuisine', 'cuisines',
    'dish', 'dishes',
    'topping', 'toppings',
    'spicy', 'delicious', 'tasty', 'yummy',
    'recipe', 'recipes',
    'calorie', 'calories',
    'ingredient', 'ingredients',
    'beverage', 'beverages',
    'sandwich', 'sandwiches',
    'fries', 'dessert', 'desserts',
    'appetizer', 'appetizers',
    'chef', 'chefs',
    'dine', 'dining', 'diner', 'eatery', 'eat', 'edible',
    'takeaway', 'takeout',
    'breakfast', 'lunch', 'dinner',
    'coffee',
  ];

  /// Word boundaries on both sides, so `SnackBar`, `createdAt`, `feature` and
  /// `repeat` are not false positives while a bare `Snack` or `Eat` is caught.
  final pattern = RegExp(
    r'\b(' + bannedTerms.join('|') + r')\b',
    caseSensitive: false,
  );

  /// `(?<!:)` keeps `https://` intact instead of treating it as a comment.
  final lineComment = RegExp(r'(?<!:)//.*');
  final blockComment = RegExp(r'/\*.*?\*/', dotAll: true);

  test('no food-specific terms remain in lib/', () {
    final lib = Directory('lib');
    expect(
      lib.existsSync(),
      isTrue,
      reason: 'Run this test from the package root.',
    );

    final offences = <String>[];

    final dartFiles = lib
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    expect(dartFiles, isNotEmpty, reason: 'No Dart sources were scanned.');

    for (final file in dartFiles) {
      final source = file.readAsStringSync().replaceAll(blockComment, '');
      final lines = source.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final code = lines[i].replaceAll(lineComment, '');
        for (final match in pattern.allMatches(code)) {
          offences.add(
            '${file.path}:${i + 1}: "${match.group(0)}" in ${code.trim()}',
          );
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason: 'Food-specific wording found:\n${offences.join('\n')}',
    );
  });
}
