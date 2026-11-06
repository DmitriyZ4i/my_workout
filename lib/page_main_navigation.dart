import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_counter.dart';
import 'page_settings.dart';
import 'page_workouts.dart';
import 'providers.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedPageProvider);

    final pages = const [
      CounterPage(),
      SettingsPage(),
      WorkoutsPage(),
    ];

    final titles = [
      tr(ref, 'counter'),
      tr(ref, 'settings'),
      tr(ref, 'workouts'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepOrange),
              child: Text(
                tr(ref, 'app_title'),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(tr(ref, 'counter')),
              selected: selectedIndex == 0,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(tr(ref, 'settings')),
              selected: selectedIndex == 1,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(tr(ref, 'workouts')),
              selected: selectedIndex == 2,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 2;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}
