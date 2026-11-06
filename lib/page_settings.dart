import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'strings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currentLang = ref.watch(selectedLanguageProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: Text(tr(ref, 'dark_theme')),
          subtitle: Text(tr(ref, 'dark_theme_sub')),
          value: isDarkMode,
          onChanged: (val) {
            ref.read(isDarkModeProvider.notifier).state = val;
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(tr(ref, 'language')),
          subtitle: Text(tr(ref, 'language_sub')),
          trailing: DropdownButton<String>(
            value: currentLang,
            onChanged: (newLang) {
              if (newLang != null) {
                ref.read(selectedLanguageProvider.notifier).state = newLang;
              }
            },
            items: AppLanguage.values.map((lang) {
              return DropdownMenuItem<String>(
                value: lang.code,
                child: Text(lang.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
