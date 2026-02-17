import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:permission_handler/permission_handler.dart';

/// Production-grade permissions service
///
/// Features:
/// - Reactive permission state tracking
/// - Context-free permission checks
/// - Proper caching and state management
/// - Comprehensive error handling
/// - Testable architecture
final class PermissionsService with MLogger implements Disposable {
  PermissionsService();

  // #########################################################################
  // REACTIVE STATES
  // #########################################################################

  final microphone = ValueNotifier(const PermissionState.unknown());
  final notifications = ValueNotifier(const PermissionState.unknown());
  final background = ValueNotifier(const PermissionState.unknown());

  // #########################################################################
  // COMMANDS
  // #########################################################################

  late final checkPermissions = Command.createAsyncNoParamNoResult(
    _checkAllPermissions,
    errorFilterFn: menoExceptionFilter,
  );

  late final requestMicrophone = Command.createAsyncNoResult(
    _requestMicrophonePermission,
    errorFilterFn: menoExceptionFilter,
  );

  late final requestNotification = Command.createAsyncNoResult(
    _requestNotificationPermission,
    errorFilterFn: menoExceptionFilter,
  );

  late final requestBackground = Command.createAsyncNoResult(
    _requestBackgroundPermission,
    errorFilterFn: menoExceptionFilter,
  );

  late final requestBroadcastPermissions = Command.createAsyncNoResult(
    _requestBroadcastPermissions,
    errorFilterFn: menoExceptionFilter,
  );

  late final enableBackgroundMode = Command.createAsync<Broadcast, bool>(
    _enableBackgroundMode,
    initialValue: false,
    errorFilterFn: menoExceptionFilter,
  );

  late final disableBackgroundMode = Command.createAsyncNoParam<bool>(
    _disableBackgroundMode,
    initialValue: false,
    errorFilterFn: menoExceptionFilter,
  );

  // #########################################################################
  // PRIVATE METHODS & HELPERS
  // #########################################################################

  /// Check all permissions status on app startup
  Future<void> _checkAllPermissions() async {
    log.d('PermissionsService: Checking all permissions');

    await Future.wait([
      _checkMicrophonePermission(),
      _checkNotificationPermission(),
      if (Platform.isAndroid) _checkBackgroundPermission(),
    ]);

    log.d('PermissionsService: All permissions checked');
  }

  /// Check microphone permission status
  Future<void> _checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      microphone.value = PermissionState.fromStatus(status);
      log.d('PermissionsService: Microphone permission - ${microphone.value}');
    } catch (e) {
      log.e('PermissionsService: Error checking microphone permission - $e');
      microphone.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  /// Check notification permission status
  Future<void> _checkNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      notifications.value = PermissionState.fromStatus(status);
      log.d(
        'PermissionsService: Notification permission - ${notifications.value}',
      );
    } catch (e) {
      log.e('PermissionsService: Error checking notification permission - $e');
      notifications.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  /// Check background permission status (Android only)
  Future<void> _checkBackgroundPermission() async {
    if (!Platform.isAndroid) {
      background.value = const PermissionState.granted();
      return;
    }

    try {
      final hasPermission = await FlutterBackground.hasPermissions;
      background.value = hasPermission
          ? const PermissionState.granted()
          : const PermissionState.denied();
      log.d('PermissionsService: Background permission - ${background.value}');
    } catch (e) {
      log.e('PermissionsService: Error checking background permission - $e');
      background.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  Future<void> _requestMicrophonePermission(PermissionContext context) async {
    log.i('PermissionsService: Requesting microphone permission');
    microphone.value = const PermissionState.requesting();

    try {
      final status = await Permission.microphone.request();
      microphone.value = PermissionState.fromStatus(status);
      log.i('PermissionsService: Microphone permission result - $status');

      switch (microphone.value) {
        case PermissionDenied():
          if (context.showRationale != null) {
            await context.showRationale?.call(
              const PermissionRationale(
                title: 'Microphone Access Required',
                message:
                    '''Microphone access is essential for broadcasting your voice to listeners. Without it, you cannot start a broadcast.''',
                permission: PermissionType.microphone,
              ),
            );
          }
        case PermissionPermanentlyDenied():
          if (context.showSettingsPrompt != null) {
            final shouldOpen = await context.showSettingsPrompt!(
              const PermissionRationale(
                title: 'Microphone Permission Required',
                message:
                    '''Microphone permission is permanently denied. Please enable it in Settings to start broadcasting.''',
                permission: PermissionType.microphone,
              ),
            );

            if (shouldOpen) {
              await openAppSettings();

              // Re-check after returning from settings
              await _checkMicrophonePermission();
            }
          }
        case PermissionGranted():
        case PermissionRestricted():
        case PermissionUnknown():
        case PermissionRequesting():
        case PermissionError():
          break;
      }
    } catch (e) {
      log.e('PermissionsService: Error requesting microphone permission - $e');
      microphone.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  Future<void> _requestNotificationPermission(PermissionContext context) async {
    log.i('PermissionsService: Requesting notification permission');

    notifications.value = const PermissionState.requesting();

    try {
      final status = await Permission.notification.request();
      notifications.value = PermissionState.fromStatus(status);

      log.i('PermissionsService: Notification permission result - $status');

      // Handle denied states
      if (notifications.value is PermissionPermanentlyDenied) {
        if (context.showSettingsPrompt != null) {
          final shouldOpen = await context.showSettingsPrompt!(
            const PermissionRationale(
              title: 'Notification Permission',
              message:
                  '''Notifications help you stay updated about your broadcasts and interactions. Enable them in Settings.''',
              permission: PermissionType.notification,
            ),
          );

          if (shouldOpen) {
            await openAppSettings();
            await _checkNotificationPermission();
          }
        }
      }
    } catch (e) {
      log.e('PermissionsService: Error requesting notification permission: $e');
      notifications.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  Future<void> _requestBackgroundPermission(PermissionContext context) async {
    if (!Platform.isAndroid) {
      background.value = const PermissionState.granted();
      return;
    }

    log.i('PermissionsService: Requesting background permission');
    background.value = const PermissionState.requesting();

    try {
      // Check if already has permission
      var hasPermission = await FlutterBackground.hasPermissions;

      if (!hasPermission) {
        // Initialize FlutterBackground
        const androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: 'Menō Broadcasting',
          notificationText: 'Broadcast is running in background',
          notificationImportance: AndroidNotificationImportance.high,
          notificationIcon: AndroidResource(name: 'ic_stat_ic_notification'),
        );

        hasPermission = await FlutterBackground.initialize(
          androidConfig: androidConfig,
        );
      }

      background.value = hasPermission
          ? const PermissionState.granted()
          : const PermissionState.denied();

      log.i('PermissionsService: Background permission result: $hasPermission');

      if (!hasPermission && context.showRationale != null) {
        await context.showRationale!(
          const PermissionRationale(
            title: 'Background Processing',
            message:
                '''Background processing allows your broadcast to continue even when you switch apps or lock your screen.''',
            permission: PermissionType.background,
          ),
        );
      }
    } catch (e) {
      log.e('PermissionsService: Error requesting background permission - $e');
      background.value = PermissionState.error(e.toString());
      throw MenoException(e.toString());
    }
  }

  Future<void> _requestBroadcastPermissions(PermissionContext context) async {
    log.i('PermissionsService: Requesting all broadcast permissions');

    // Check current states first
    await _checkAllPermissions();

    // Request microphone (critical)
    if (microphone.value is! PermissionGranted) {
      await _requestMicrophonePermission(context);
    }

    // If microphone denied, stop here
    if (microphone.value is! PermissionGranted) {
      log.w('PermissionsService: Microphone not granted, aborting');
      return;
    }

    // Request background (Android only, critical for streaming)
    if (Platform.isAndroid && background.value is! PermissionGranted) {
      await _requestBackgroundPermission(context);
    }

    // Request notifications (nice to have, but not critical)
    if (notifications.value is! PermissionGranted) {
      await _requestNotificationPermission(context);
    }

    log.i('PermissionsService: Broadcast permissions flow completed');
  }

  /// Enable background mode (must be called after permission is granted)
  Future<bool> _enableBackgroundMode(Broadcast broadcast) async {
    if (!Platform.isAndroid) return true;

    try {
      log.i('PermissionsService: Enabling background mode');

      final config = FlutterBackgroundAndroidConfig(
        notificationTitle: broadcast.title.getOrCrash(),
        notificationText: broadcast.effectiveCreatorName.getOrCrash(),
        notificationIcon: const AndroidResource(
          name: 'ic_stat_ic_notification',
        ),
      );

      // Initialize with custom config
      final success = await FlutterBackground.initialize(androidConfig: config);

      if (success && !FlutterBackground.isBackgroundExecutionEnabled) {
        return await FlutterBackground.enableBackgroundExecution();
      }

      return success;
    } catch (e) {
      log.e('PermissionsService: Error enabling background mode - $e');
      return false;
    }
  }

  /// Disable background mode
  Future<bool> _disableBackgroundMode() async {
    if (!Platform.isAndroid) return true;

    try {
      log.i('PermissionsService: Disabling background mode');
      final success = await FlutterBackground.disableBackgroundExecution();
      log.i('PermissionsService: Background mode disabled - $success');
      return success;
    } catch (e) {
      log.e('PermissionsService: Error disabling background mode - $e');
      return false;
    }
  }

  /// Check if all critical broadcast permissions are granted
  bool get canBroadcast {
    final microphoneGranted = microphone.value is PermissionGranted;
    final backgroundGranted =
        !Platform.isAndroid || background.value is PermissionGranted;
    return microphoneGranted && backgroundGranted;
  }

  /// Check if permission should show rationale
  Future<bool> shouldShowRationale(PermissionType type) async {
    return switch (type) {
      .microphone => await Permission.microphone.shouldShowRequestRationale,
      .notification => await Permission.notification.shouldShowRequestRationale,
      .background => false,
    };
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('PermissionsService: Disposing');

    microphone.dispose();
    notifications.dispose();
    background.dispose();

    checkPermissions.dispose();
    requestMicrophone.dispose();
    requestNotification.dispose();
    requestBackground.dispose();
    requestBroadcastPermissions.dispose();

    enableBackgroundMode.dispose();
    disableBackgroundMode.dispose();
  }
}

// #########################################################################
// PERMISSION STATES
// #########################################################################

sealed class PermissionState {
  const PermissionState();

  const factory PermissionState.unknown() = PermissionUnknown;

  const factory PermissionState.requesting() = PermissionRequesting;

  const factory PermissionState.granted() = PermissionGranted;

  const factory PermissionState.denied() = PermissionDenied;

  const factory PermissionState.permanentlyDenied() =
      PermissionPermanentlyDenied;

  const factory PermissionState.restricted() = PermissionRestricted;

  const factory PermissionState.error(String message) = PermissionError;

  factory PermissionState.fromStatus(PermissionStatus status) {
    return switch (status) {
      .granted || .limited => const PermissionState.granted(),
      .denied => const PermissionState.denied(),
      .permanentlyDenied => const PermissionState.permanentlyDenied(),
      .restricted => const PermissionState.restricted(),
      .provisional => const PermissionState.granted(),
    };
  }
}

final class PermissionUnknown extends PermissionState {
  const PermissionUnknown();
}

final class PermissionRequesting extends PermissionState {
  const PermissionRequesting();
}

final class PermissionGranted extends PermissionState {
  const PermissionGranted();
}

final class PermissionDenied extends PermissionState {
  const PermissionDenied();
}

final class PermissionPermanentlyDenied extends PermissionState {
  const PermissionPermanentlyDenied();
}

final class PermissionRestricted extends PermissionState {
  const PermissionRestricted();
}

final class PermissionError extends PermissionState {
  const PermissionError(this.message);

  final String message;
}

// #########################################################################
// PERMISSION TYPE
// #########################################################################

enum PermissionType { microphone, notification, background }

extension PermissionTypeX on PermissionType {
  String get displayName {
    return switch (this) {
      PermissionType.microphone => 'Microphone',
      PermissionType.notification => 'Notifications',
      PermissionType.background => 'Background Processing',
    };
  }
}

// #########################################################################
// OTHER TYPES
// #########################################################################

/// Context for permission requests
///
/// Separates permission logic from UI concerns
@immutable
final class PermissionContext {
  const PermissionContext({this.showRationale, this.showSettingsPrompt});

  /// Callback to show educational rationale to user
  final Future<void> Function(PermissionRationale)? showRationale;

  /// Callback to prompt user to open settings
  /// Returns true if user wants to open settings
  final Future<bool> Function(PermissionRationale)? showSettingsPrompt;
}

/// Permission rationale data
@immutable
final class PermissionRationale {
  const PermissionRationale({
    required this.title,
    required this.message,
    required this.permission,
  });

  final String title;
  final String message;
  final PermissionType permission;
}
