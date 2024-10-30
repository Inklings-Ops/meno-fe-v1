import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@Injectable()
class PermissionsService {
  @PostConstruct(preResolve: true)
  Future<void> checkPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    status = await Permission.bluetoothConnect.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Future<void> requestNotificationsPermissions() async {
  //   final status = await Permission.notification.request();
  //   if (status.) {
  //     await openAppSettings();
  //   }
  // }
}
