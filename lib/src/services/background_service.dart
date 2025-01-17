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
