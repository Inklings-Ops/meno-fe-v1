
// ignore_for_file: join_return_with_assignment

import 'package:flutter_background/flutter_background.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:permission_handler/permission_handler.dart';

const _maxRetries = 5;

@singleton
class PermissionsService {
  bool _notificationPermissionStatus = false;
  bool _microphonePermissionStatus = false;
  bool _backgroundPermissionStatus = false;

  int _retryCount = 0;
  bool get microphonePermissionStatus => _microphonePermissionStatus;
  bool get notificationPermissionStatus => _notificationPermissionStatus;
  bool get backgroundPermissionStatus => _backgroundPermissionStatus;

  Future<bool> _requestBackgroundProceses() async {
    var result = await FlutterBackground.hasPermissions;
    result = await FlutterBackground.initialize().then((value) async {
      if (!value) return FlutterBackground.initialize();
      return result;
    });
    return result;
  }

  Future<bool> requestBackgroundProcesses(BuildContext context) async {
    _backgroundPermissionStatus = await _requestBackgroundProceses();
    if (context.mounted) {
      if (!_backgroundPermissionStatus) {
        await context.showPermissionsRequestDialog(
          title: 'Background Processes',
          message: 'Allow Menō to run in the background',
          onTryAgain: () async {
            router.pop();
            final status = await _requestBackgroundProceses();
            if (status) {
              _retryCount = 0;
            }
          },
        );
      }
    }
    return _backgroundPermissionStatus;
  }

  Future<bool> requestMicPermissions(BuildContext context) async {
    await _handlePermissionsRequest(
      context: context,
      permission: Permission.microphone,
      onGranted: () => _microphonePermissionStatus = true,
      title: 'Microphone',
      message: 'Microphone permission is needed to start a broadcast.',
    );
    return _microphonePermissionStatus;
  }

  Future<bool> requestNotificationsPermissions(BuildContext context) async {
    await _handlePermissionsRequest(
      context: context,
      permission: Permission.notification,
      onGranted: () => _notificationPermissionStatus = true,
      title: 'Notifications',
      message: 'Notifications permission is needed to start a broadcast.',
    );
    return _notificationPermissionStatus;
  }

  Future<void> _handlePermissionsRequest({
    required BuildContext context,
    required Permission permission,
    required VoidCallback onGranted,
    required String title,
    required String message,
  }) async {
    final permissionStatus = await permission.request();
    if (context.mounted) {
      if (permissionStatus.isDenied) {
        await _retryPermissionRequest(
          context: context,
          permissionRequest: () async => permission.request(),
          title: title,
          message: message,
        );
      } else if (permissionStatus.isPermanentlyDenied) {
        await promptRedirect(context, title);
      } else {
        onGranted();
        _retryCount = 0;
      }
    }
  }

  Future<void> promptRedirect(BuildContext context, String title) async {
    final shouldRedirect = await context.showPermissionRedirectDialog(
      '''You need to enable $title permissions in Settings to use this feature. Would you like to open Settings now?''',
    );

    if (shouldRedirect != null && shouldRedirect == true) {
      await openAppSettings();
    }
  }

  Future<void> _retryPermissionRequest({
    required BuildContext context,
    required Future<PermissionStatus> Function() permissionRequest,
    required String title,
    required String message,
  }) async {
    await context.showPermissionsRequestDialog(
      title: title,
      message: message,
      onTryAgain: () async {
        router.pop();
        if (_retryCount < _maxRetries) {
          _retryCount++;
          final status = await permissionRequest();
          if (status.isGranted) {
            _retryCount = 0;
          }
        } else {
          context.showErrorSnackBar(
            'Too many attempts. Please enable permissions in Settings.',
          );
        }
      },
    );
  }
}
