import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../features/auth/domain/domain.dart';
import '../../features/broadcast/domain/domain.dart';
import '../constants/m_error_messages.dart';

typedef MMessenger = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>;

extension MSnackBarExtensions on BuildContext {
  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();

  MMessenger showErrorSnackBar(String message) {
    final  colorScheme = MColorScheme.of(this);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme?.error,
        behavior: SnackBarBehavior.floating,
        content: MText(
          message,
          style: MTextStyle.captionRegular,
          color: colorScheme?.onError,
        ),
      ),
    );
  }

  MMessenger showLoginError(AuthException exception) {
    return showErrorSnackBar(
      exception.maybeMap(
        orElse: () => '',
        invalidEmailOrPassword: (_) => MErrorMessages.invalidEmailOrPassword,
        networkError: (_) => MErrorMessages.networkError,
        serverError: (_) => MErrorMessages.serverError,
        timeOutError: (_) => MErrorMessages.timeOutError,
        unknownError: (_) => MErrorMessages.unknownError,
      ),
    );
  }

  MMessenger showBroadcastError(dynamic exception) {
    return showErrorSnackBar(
      (exception as BroadcastException).maybeMap(
        orElse: () => '',
        message: (value) => value.message,
        networkError: (_) => MErrorMessages.networkError,
        serverError: (_) => MErrorMessages.serverError,
        timeOutError: (_) => MErrorMessages.timeOutError,
      ),
    );
  }

  MMessenger showRegistrationError(AuthException exception) {
    return showErrorSnackBar(
      exception.maybeMap(
        orElse: () => '',
        emailAlreadyInUse: (_) => MErrorMessages.emailAlreadyInUse,
        networkError: (_) => MErrorMessages.networkError,
        serverError: (_) => MErrorMessages.serverError,
        timeOutError: (_) => MErrorMessages.timeOutError,
        unknownError: (_) => MErrorMessages.unknownError,
      ),
    );
  }
}
