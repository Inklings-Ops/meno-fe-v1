// import 'dart:developer';
// import 'dart:ui';

// import 'package:injectable/injectable.dart';
// import 'package:meno_fe_v1/meno.dart';
// import 'package:meno_fe_v1/src/services/services.dart';

// @Injectable()
// class MenoConfig {
//   Size _appSize = Size.zero;

//   /// Indicates to the rest of the app that bootstrap has not completed.
//   /// The router will use this to prevent redirects while bootstrapping.
//   bool isBootstrapComplete = false;

//   /// Indicates which orientations the app will allow be default. Affects Android/iOS devices only.
//   /// Defaults to both landscape (hz) and portrait (vt)
//   List<Axis> supportedOrientations = [Axis.vertical, Axis.horizontal];

//   /// Allow a view to override the currently supported orientations. For example, [FullscreenVideoViewer] always wants to enable both landscape and portrait.
//   /// If a view sets this override, they are responsible for setting it back to null when finished.
//   List<Axis>? _supportedOrientationsOverride;
//   set supportedOrientationsOverride(List<Axis>? value) {
//     if (_supportedOrientationsOverride != value) {
//       _supportedOrientationsOverride = value;
//       _updateSystemOrientation();
//     }
//   }

//   Future<void> bootstrap() async {
//     log('bootstrap start...');
//     isBootstrapComplete = true;
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     log('...bootstrap complete');
//     // AppRouter().push(route)
//     // router.go(initialDeepLink ?? Routes.home);
//   }

//   Display get display => PlatformDispatcher.instance.displays.first;

//   bool shouldUseNavRail() =>
//       _appSize.width > _appSize.height && _appSize.height > 250;

//   /// Called from the UI layer once a MediaQuery has been obtained
//   void handleAppSizeChanged(Size appSize) {
//     /// Disable landscape layout on smaller form factors
//     final isSmall = display.size.shortestSide / display.devicePixelRatio < 600;
//     supportedOrientations =
//         isSmall ? [Axis.vertical] : [Axis.vertical, Axis.horizontal];
//     _updateSystemOrientation();
//     _appSize = appSize;
//   }

//   void _updateSystemOrientation() {
//     final axisList = _supportedOrientationsOverride ?? supportedOrientations;
//     //debugPrint('updateDeviceOrientation, supportedAxis: $axisList');
//     final orientations = <DeviceOrientation>[];
//     if (axisList.contains(Axis.vertical)) {
//       orientations.addAll([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//     }
//     if (axisList.contains(Axis.horizontal)) {
//       orientations.addAll([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     }
//     SystemChrome.setPreferredOrientations(orientations);
//   }
// }

// // Entry point for handling background messages from Firebase Cloud Messaging.
// // This function is marked as an entry point for the VM to ensure it's
// // accessible even when the app is in the background.
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Future.wait([
//     // Initializes Firebase app again, as it might not be running in the background.
//     Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),

//     // Requests notification permissions from the user.
//     FirebaseMessaging.instance.requestPermission(),

//     // Handles the FCM token (implementation details not shown).
//     handleFCMToken(),

//     // Sets up local notifications for the app.
//     setupFlutterNotifications(),
//   ]);

//   // Displays a Flutter notification based on the received message.
//   showFlutterNotification(message);
// }
