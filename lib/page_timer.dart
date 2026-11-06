import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'widgets.dart';

enum TimerType { countdown, stopwatch }

class TimerState {
  final TimerType type;
  final Duration totalDuration;
  final Duration elapsed;
  final bool isRunning;

  const TimerState({
    required this.type,
    required this.totalDuration,
    required this.elapsed,
    required this.isRunning,
  });

  TimerState copyWith({
    TimerType? type,
    Duration? totalDuration,
    Duration? elapsed,
    bool? isRunning,
  }) {
    return TimerState(
      type: type ?? this.type,
      totalDuration: totalDuration ?? this.totalDuration,
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Duration get remaining {
    if (type == TimerType.countdown) {
      final rem = totalDuration - elapsed;
      return rem.isNegative ? Duration.zero : rem;
    } else {
      return elapsed;
    }
  }

  double get progress {
    if (type == TimerType.countdown) {
      if (totalDuration.inMilliseconds == 0) return 0.0;
      return remaining.inMilliseconds / totalDuration.inMilliseconds;
    } else {
      return (elapsed.inMilliseconds % 60000) / 60000.0;
    }
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier()
      : super(
          const TimerState(
            type: TimerType.countdown,
            totalDuration: Duration(minutes: 1),
            elapsed: Duration.zero,
            isRunning: false,
          ),
        );

  void setType(TimerType type) {
    _timer?.cancel();
    state = TimerState(
      type: type,
      totalDuration: const Duration(minutes: 1),
      elapsed: Duration.zero,
      isRunning: false,
    );
  }

  void startOrPause() {
    if (state.isRunning) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() {
    if (state.type == TimerType.countdown && state.remaining == Duration.zero) {
      state = state.copyWith(elapsed: Duration.zero);
    }
    _timer?.cancel();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      final newElapsed = state.elapsed + const Duration(milliseconds: 30);
      if (state.type == TimerType.countdown && newElapsed >= state.totalDuration) {
        timer.cancel();
        state = state.copyWith(
          elapsed: state.totalDuration,
          isRunning: false,
        );
      } else {
        state = state.copyWith(elapsed: newElapsed);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      elapsed: Duration.zero,
      isRunning: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final millis =
        (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds:$millis';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final notifier = ref.read(timerProvider.notifier);

    return Column(
      children: [
        const SizedBox(height: 16),
        SegmentedButton<TimerType>(
          segments: [
            ButtonSegment<TimerType>(
              value: TimerType.countdown,
              label: Text(tr(ref, 'countdown')),
              icon: const Icon(Icons.hourglass_bottom),
            ),
            ButtonSegment<TimerType>(
              value: TimerType.stopwatch,
              label: Text(tr(ref, 'stopwatch')),
              icon: const Icon(Icons.timer),
            ),
          ],
          selected: {timerState.type},
          onSelectionChanged: (newSelection) {
            notifier.setType(newSelection.first);
          },
        ),
        const Spacer(),
        SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value: timerState.progress,
                  strokeWidth: 12,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                _formatDuration(timerState.remaining),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                icon: timerState.isRunning ? Icons.pause : Icons.play_arrow,
                text: timerState.isRunning
                    ? tr(ref, 'pause')
                    : tr(ref, 'start'),
                onPressed: () => notifier.startOrPause(),
              ),
              AppButton(
                icon: Icons.stop,
                text: tr(ref, 'stop'),
                onPressed: () => notifier.stop(),
              ),
              AppButton(
                icon: Icons.refresh,
                text: tr(ref, 'reset'),
                onPressed: () => notifier.reset(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
