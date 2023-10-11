import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../features/auth/domain/domain.dart';
import '../../features/broadcast/domain/domain.dart';
import '../constants/m_error_messages.dart';

typedef MMessenger = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>;

extension MSnackBarExtensions on BuildContext {
  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();

  MMessenger _showErrorSnackBar(String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: MText(
          message,
          style: MTextStyle.captionRegular,
          color: MColorScheme.of(this)?.onError,
        ),
      ),
    );
  }

  MMessenger showLoginError(AuthException exception) {
    return _showErrorSnackBar(
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

  MMessenger showBroadcastFormError(BroadcastException exception) {
    return _showErrorSnackBar(
      exception.maybeMap(orElse: () => '', message: (value) => value.message),
    );
  }

  MMessenger showRegistrationError(AuthException exception) {
    return _showErrorSnackBar(
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
