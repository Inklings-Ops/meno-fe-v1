import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:permission_handler/permission_handler.dart';

const _maxRetries = 5;

@singleton
class PermissionsService {
  bool _notificationPermissionStatus = false;
  bool get notificationPermissionStatus => _notificationPermissionStatus;

  bool _microphonePermissionStatus = false;
  bool get microphonePermissionStatus => _microphonePermissionStatus;

  int _retryCount = 0;

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
        await _promptRedirect(context, title);
      } else {
        onGranted();
        _retryCount = 0;
      }
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

  Future<void> _promptRedirect(BuildContext context, String message) async {
    final shouldRedirect = await context.showPermissionRedirectDialog(
      '''You need to enable $message permissions in Settings to use this feature. Would you like to open Settings now?''',
    );

    if (shouldRedirect != null && shouldRedirect == true) {
      await openAppSettings();
    }
  }
}
