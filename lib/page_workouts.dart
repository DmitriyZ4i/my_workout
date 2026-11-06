import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class WorkoutsPage extends ConsumerWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(tr(ref, 'workout_a_title')),
            subtitle: Text(tr(ref, 'workout_a_sub')),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.directions_run),
            title: Text(tr(ref, 'workout_b_title')),
            subtitle: Text(tr(ref, 'workout_b_sub')),
          ),
        ),
      ],
    );
  }
}
