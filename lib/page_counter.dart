import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'widgets.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr(ref, 'counter_label'),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          AppButton(
            icon: Icons.add,
            text: tr(ref, 'counter'),
            onPressed: () => ref.read(counterProvider.notifier).state++,
          ),
        ],
      ),
    );
  }
}
