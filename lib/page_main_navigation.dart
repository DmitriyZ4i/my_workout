import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_counter.dart';
import 'page_settings.dart';
import 'page_timer.dart';
import 'page_workouts.dart';
import 'providers.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  late final PageController _pageController;

  final List<IconData> _pageIcons = const [
    Icons.add_circle_outline,
    Icons.settings,
    Icons.fitness_center,
    Icons.timer,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: ref.read(selectedPageProvider));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(selectedPageProvider.notifier).state = index;
  }

  void _nextPage() {
    final current = ref.read(selectedPageProvider);
    if (current < 3) {
      _pageController.animateToPage(
        current + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    final current = ref.read(selectedPageProvider);
    if (current > 0) {
      _pageController.animateToPage(
        current - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedPageProvider);

    ref.listen<int>(selectedPageProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    final pages = const [
      CounterPage(),
      SettingsPage(),
      WorkoutsPage(),
      TimerPage(),
    ];

    final titles = [
      tr(ref, 'counter'),
      tr(ref, 'settings'),
      tr(ref, 'workouts'),
      tr(ref, 'timer'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        scrolledUnderElevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange.shade900),
              child: Text(
                tr(ref, 'app_title'),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(_pageIcons[0]),
              title: Text(tr(ref, 'counter')),
              selected: selectedIndex == 0,
              selectedTileColor: Colors.orange.withValues(alpha: 0.2),
              selectedColor: Colors.deepOrange,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(_pageIcons[1]),
              title: Text(tr(ref, 'settings')),
              selected: selectedIndex == 1,
              selectedTileColor: Colors.orange.withValues(alpha: 0.2),
              selectedColor: Colors.deepOrange,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(_pageIcons[2]),
              title: Text(tr(ref, 'workouts')),
              selected: selectedIndex == 2,
              selectedTileColor: Colors.orange.withValues(alpha: 0.2),
              selectedColor: Colors.deepOrange,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 2;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(_pageIcons[3]),
              title: Text(tr(ref, 'timer')),
              selected: selectedIndex == 3,
              selectedTileColor: Colors.orange.withValues(alpha: 0.2),
              selectedColor: Colors.deepOrange,
              onTap: () {
                ref.read(selectedPageProvider.notifier).state = 3;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            children: pages,
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    _nextPage();
                  } else if (details.primaryVelocity! > 0) {
                    _previousPage();
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Opacity(
                  opacity: 0.25,
                  child: Icon(
                    _pageIcons[selectedIndex],
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
