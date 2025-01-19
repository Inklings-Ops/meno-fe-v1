import 'dart:io';

import 'package:flutter_background/flutter_background.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/features.dart';

@lazySingleton
class BackgroundService {
  Future<bool> startBroadcastBackgroundProcess(Broadcast broadcast) async {
    if (Platform.isAndroid) {
      try {
        final androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: broadcast.title.getOr(),
          notificationText: broadcast.creator?.fullName ??
              broadcast.fullName ??
              broadcast.creatorFullName ??
              '',
          notificationIcon: const AndroidResource(
            name: 'ic_stat_ic_notification',
          ),
        );
        final permitted = await FlutterBackground.initialize(
          androidConfig: androidConfig,
        );

        if (permitted && !FlutterBackground.isBackgroundExecutionEnabled) {
          return await FlutterBackground.enableBackgroundExecution();
        }
        return permitted;
      } catch (e) {
        Logger().e('Error in background permission request: $e');
        throw Exception(e);
      }
    }
    return false;
  }

  Future<void> stopBroadcastBackgroundProcess() async {
    if (Platform.isAndroid) {
      try {
        await FlutterBackground.disableBackgroundExecution();
      } catch (e) {
        Logger().e('Could not stop background process => $e');
      }
    }
  }
}

// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:injectable/injectable.dart';
// import 'package:meno_fe_v1/meno.dart';

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   if (service is IOSServiceInstance) {
//     service.on(MKeys.broadcastBackgroundTask).listen((event) async {
//       // await service.();
//     });
//   }

//   return true;
// }

// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on(MKeys.broadcastBackgroundTask).listen((event) async {
//       await Future.wait([
//         service.setAsForegroundService(),
//         service.setAsBackgroundService(),
//       ]);
//     });
//     service.on(MKeys.streamBackgroundTask).listen((event) async {
//       await Future.wait([
//         service.setAsForegroundService(),
//         service.setAsBackgroundService(),
//       ]);
//     });
//     service.on(MKeys.endBackgroundTask).listen((event) async {
//       await service.stopSelf();
//     });
//   }
// }

// @lazySingleton
// class BackgroundService {
//   final _service = FlutterBackgroundService();

//   Future<void> initializeBackgroundService() async {
//     await _service.configure(
//       iosConfiguration: IosConfiguration(
//         autoStart: false,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: false,
//         autoStart: false,
//       ),
//     );
//   }

//   Future<void> invokeBroadcastInBackground() async {
//     if (await _service.isRunning() == false) {
//       _service.invoke(MKeys.broadcastBackgroundTask);
//     }
//   }

//   Future<void> invokeStreamInBackground() async {
//     if (await _service.isRunning() == false) {
//       _service.invoke(MKeys.streamBackgroundTask);
//     }
//   }

//   void endBackgroundTask() => _service.invoke(MKeys.endBackgroundTask);

//   Future<void> startBackgroundService() => _service.startService();
// }
