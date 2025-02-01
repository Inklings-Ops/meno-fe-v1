import 'dart:io';

import 'package:flutter_background/flutter_background.dart';
import 'package:injectable/injectable.dart';
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
        throw Exception(e);
      }
    }
  }
}
