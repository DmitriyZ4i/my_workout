import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'strings.dart';

final selectedPageProvider = StateProvider<int>((ref) => 0);
final counterProvider = StateProvider<int>((ref) => 0);
final isDarkModeProvider = StateProvider<bool>((ref) => false);
final selectedLanguageProvider = StateProvider<String>((ref) => 'en');

String tr(WidgetRef ref, String key) {
  final lang = ref.watch(selectedLanguageProvider);
  return appStrings[lang]?[key] ?? appStrings['en']?[key] ?? key;
}
