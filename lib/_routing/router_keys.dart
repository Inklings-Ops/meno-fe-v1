import 'package:flutter/material.dart';

/// Centralised navigator keys for every shell and branch in the app.
final class RouterKeys {
  const RouterKeys._();

  // Root
  static final root = GlobalKey<NavigatorState>(debugLabel: 'root');

  // Live Session branches
  static final liveBroadcast = GlobalKey<NavigatorState>(
    debugLabel: 'live_broadcast',
  );
  static final liveChat = GlobalKey<NavigatorState>(debugLabel: 'live_chat');
  static final liveBible = GlobalKey<NavigatorState>(debugLabel: 'live_bible');
  static final liveNotes = GlobalKey<NavigatorState>(debugLabel: 'live_notes');

  // Main shell branches
  static final home = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final discover = GlobalKey<NavigatorState>(debugLabel: 'discover');
  static final notes = GlobalKey<NavigatorState>(debugLabel: 'notes');
  static final profile = GlobalKey<NavigatorState>(debugLabel: 'profile');
}
