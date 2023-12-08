import 'package:flutter/material.dart';

class MKeys {
  MKeys._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static const String userKey = "_user_";
  static const String allUserCredentialsKey = "_all_user_credentials_";
  static const String currentUserKey = "_current_user_";
  static const String currentProfileKey = "_current_profile_";
  static const String currentUserTokenKey = "_current_user_token_";
  static const String userTokenKey = "_user_token_";
  static const String onboardingKey = "_onboarding_";
  static const String fcmToken = "_fcm_Token";
}
