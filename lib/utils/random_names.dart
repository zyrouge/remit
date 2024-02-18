import 'list.dart';
import 'random.dart';

abstract class RuiRandomNames {
  static const List<String> words = <String>[
    'area',
    'book',
    'business',
    'case',
    'child',
    'company',
    'country',
    'day',
    'eye',
    'fact',
    'family',
    'government',
    'group',
    'hand',
    'home',
    'job',
    'life',
    'lot',
    'man',
    'money',
    'month',
    'mother',
    'mr',
    'night',
    'number',
    'part',
    'people',
    'place',
    'point',
    'problem',
    'program',
    'question',
    'right',
    'room',
    'school',
    'state',
    'story',
    'student',
    'study',
    'system',
    'thing',
    'time',
    'water',
    'way',
    'week',
    'woman',
    'word',
    'work',
    'world',
    'year',
  ];

  static String generate() {
    final String word1 = words.random();
    final String word2 = words.random();
    final String number = ruiRandom.nextInt(999).toString().padLeft(3, '0');
    return '$word1-$word2-$number';
  }
}
