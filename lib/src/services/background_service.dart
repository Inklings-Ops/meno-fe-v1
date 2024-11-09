import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on(MKeys.broadcastBackgroundTask).listen((event) async {
      await Future.wait([
        service.setAsForegroundService(),
        service.setAsBackgroundService(),
      ]);
    });
    service.on(MKeys.streamBackgroundTask).listen((event) async {
      await Future.wait([
        service.setAsForegroundService(),
        service.setAsBackgroundService(),
      ]);
    });
    service.on(MKeys.endBackgroundTask).listen((event) async {
      await service.stopSelf();
    });
  }

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        await service.setForegroundNotificationInfo(
          title: 'Meno',
          content: 'Meno is running in the background',
        );
      }
    }
  });
}

@lazySingleton
class BackgroundService {
  final _service = FlutterBackgroundService();

  Future<void> initializeBackgroundService() async {
    await _service.configure(
      iosConfiguration: IosConfiguration(autoStart: false),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: false,
      ),
    );
  }

  Future<void> startBroadcastInBackground(Broadcast broadcast) async {
    if (await _service.isRunning()) {
      _service.invoke(MKeys.broadcastBackgroundTask, {
        'broadcastId': broadcast.id.getOr(),
        'broadcastToken': broadcast.broadcastToken,
      });
    }
  }
}
