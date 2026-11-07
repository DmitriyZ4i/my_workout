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

  void setDuration(Duration duration) {
    _timer?.cancel();
    state = state.copyWith(
      totalDuration: duration,
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

  Widget _buildTimeDisplay(Duration duration, double fontSize) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final millis =
        (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$minutes:$seconds',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ':$millis',
          style: TextStyle(
            fontSize: fontSize * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showSetTimeDialog(BuildContext context, WidgetRef ref) {
    final currentDuration = ref.read(timerProvider).totalDuration;
    int selectedMinutes = currentDuration.inMinutes.remainder(60);
    int selectedSeconds = currentDuration.inSeconds.remainder(60);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(child: Text(tr(ref, 'set_time'))),
              content: SizedBox(
                height: 180,
                width: 260,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Min', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 38,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(
                                initialItem: selectedMinutes,
                              ),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedMinutes = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: index == selectedMinutes
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: index == selectedMinutes
                                            ? Theme.of(context).colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Sec', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 38,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(
                                initialItem: selectedSeconds,
                              ),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedSeconds = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: index == selectedSeconds
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: index == selectedSeconds
                                            ? Theme.of(context).colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newDuration = Duration(
                      minutes: selectedMinutes,
                      seconds: selectedSeconds,
                    );
                    if (newDuration.inSeconds > 0) {
                      ref.read(timerProvider.notifier).setDuration(newDuration);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final notifier = ref.read(timerProvider.notifier);

    final screenSize = MediaQuery.sizeOf(context);
    final smallerSide = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    final circleSize = smallerSide * 0.8;
    final fontSize = circleSize * 0.12;

    final startButtonSize = smallerSide * 0.18;
    final resetButtonSize = startButtonSize * 0.75;

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
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: circleSize,
                height: circleSize,
                child: CircularProgressIndicator(
                  value: timerState.progress,
                  strokeWidth: circleSize * 0.04,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeDisplay(timerState.remaining, fontSize),
                  if (timerState.type == TimerType.countdown) ...[
                    const SizedBox(height: 12),
                    MyButton(
                      icon: Icons.timer,
                      text: tr(ref, 'set_time'),
                      onPressed: () => _showSetTimeDialog(context, ref),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 24),
              MyRoundButton(
                size: startButtonSize,
                icon: timerState.isRunning ? Icons.pause : Icons.play_arrow,
                onPressed: () => notifier.startOrPause(),
              ),
              const SizedBox(width: 24),
              MyRoundButton(
                size: resetButtonSize,
                icon: Icons.refresh,
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
