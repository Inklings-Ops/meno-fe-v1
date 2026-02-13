import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';

/// Application layer - Live Timer Manager
///
/// Manages the elapsed time for a broadcast session with:
/// - Automatic start/stop based on LiveKit connection
/// - Persistence across app restarts (zombie recovery)
/// - Pause/resume on network interruptions
/// - Accurate time tracking even during disconnections
/// - Reactive state updates via Flutter IT
///
/// Lives in the live session scope (per broadcast)
final class LiveTimerManager with MenoLogger implements Disposable {
  LiveTimerManager({
    required DateTime broadcastStartTime,
    Duration? initialElapsed,
  }) : _broadcastStartTime = broadcastStartTime,
       _initialElapsed = initialElapsed ?? Duration.zero {
    _initialize();
  }

  final DateTime _broadcastStartTime;
  final Duration _initialElapsed;

  Timer? _timer;
  DateTime? _pausedAt;
  Duration _accumulatedPauseDuration = Duration.zero;

  // Reactive state
  late final elapsed = ValueNotifier<Duration>(_initialElapsed);
  late final isRunning = ValueNotifier<bool>(false);

  /// Formatted time string (HH:MM:SS)
  late final formattedTime = elapsed.map((duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  });

  /// Time ago string (e.g., "2m ago", "1h ago")
  late final timeAgo = elapsed.map((duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return '${duration.inSeconds}s ago';
    }
  });

  // #####################################################################
  // COMMANDS
  // #####################################################################

  late final start = Command.createSyncNoParamNoResult(_start);
  late final pause = Command.createSyncNoParamNoResult(_pause);
  late final resume = Command.createSyncNoParamNoResult(_resume);
  late final stop = Command.createSyncNoParamNoResult(_stop);
  late final reset = Command.createSyncNoParamNoResult(_reset);

  // #####################################################################
  // PRIVATE METHODS
  // #####################################################################

  void _initialize() {
    log.d('BroadcastTimerManager: Initializing');

    // Calculate initial elapsed time from broadcast start time
    final now = DateTime.now();
    final actualElapsed = now.difference(_broadcastStartTime);

    // Use the greater of: calculated elapsed or provided initial elapsed
    // This handles zombie recovery where we might have a cached elapsed time
    elapsed.value = actualElapsed > _initialElapsed
        ? actualElapsed
        : _initialElapsed;

    log.i('BroadcastTimerManager: Initial elapsed ${elapsed.value.inSeconds}s');
  }

  /// Start the timer
  void _start() {
    if (_timer?.isActive ?? false) {
      log.d('BroadcastTimerManager: Timer already running');
      return;
    }

    log.i('BroadcastTimerManager: Starting timer');

    isRunning.value = true;
    _pausedAt = null;

    // Start periodic timer (ticks every second)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Pause the timer (preserves current elapsed time)
  ///
  /// Used when:
  /// - LiveKit disconnects (network issue)
  /// - Host manually pauses
  /// - Phone call interrupts
  void _pause() {
    if (!isRunning.value) {
      log.d('BroadcastTimerManager: Timer not running, cannot pause');
      return;
    }

    log.i('BroadcastTimerManager: Pausing timer');

    _timer?.cancel();
    _timer = null;
    _pausedAt = DateTime.now();
    isRunning.value = false;
  }

  /// Resume the timer after pause
  ///
  /// Calculates pause duration and adjusts accordingly
  void _resume() {
    if (isRunning.value) {
      log.d('BroadcastTimerManager: Timer already running');
      return;
    }

    if (_pausedAt != null) {
      // Calculate how long we were paused
      final pauseDuration = DateTime.now().difference(_pausedAt!);
      _accumulatedPauseDuration += pauseDuration;

      log.i(
        '''BroadcastTimerManager: Resuming after ${pauseDuration.inSeconds}s pause''',
      );
    }

    _start();
  }

  /// Stop the timer (keeps elapsed time)
  void _stop() {
    log.i('BroadcastTimerManager: Stopping timer');

    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
  }

  /// Reset the timer to zero
  void _reset() {
    log.i('BroadcastTimerManager: Resetting timer');

    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
    elapsed.value = Duration.zero;
    _accumulatedPauseDuration = Duration.zero;
    _pausedAt = null;
  }

  /// Timer tick - updates elapsed time
  void _tick() {
    final now = DateTime.now();

    // Calculate true elapsed time:
    // Current time - Start time - Total pause duration
    final trueElapsed =
        now.difference(_broadcastStartTime) - _accumulatedPauseDuration;

    elapsed.value = trueElapsed;
  }

  /// Get current elapsed duration (for persistence)
  Duration get currentElapsed => elapsed.value;

  /// Get total pause duration (for analytics)
  Duration get totalPauseDuration => _accumulatedPauseDuration;

  /// Calculate broadcast quality score based on pauses
  ///
  /// Returns a percentage (0-100) where:
  /// - 100% = no pauses
  /// - Lower % = more pause time relative to total time
  double get qualityScore {
    if (elapsed.value.inSeconds == 0) return 100;

    final pausePercentage =
        (_accumulatedPauseDuration.inSeconds / elapsed.value.inSeconds) * 100;

    return (100 - pausePercentage).clamp(0.0, 100.0);
  }

  @override
  FutureOr<void> onDispose() {
    log.d('BroadcastTimerManager: Disposing');

    _timer?.cancel();
    _timer = null;

    elapsed.dispose();
    isRunning.dispose();

    start.dispose();
    pause.dispose();
    resume.dispose();
    stop.dispose();
    reset.dispose();
  }
}
