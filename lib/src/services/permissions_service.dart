import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class PermissionsService {
  Future<void> requestNotificationsPermissions() async {
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied || status.isDenied) {
      await openAppSettings();
    }
  }

  Future<void> requestMicrophonePermissions() async {
    var status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    status = await Permission.bluetoothConnect.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
