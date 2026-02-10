import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/shared/shared.dart';

void setupGlobalExceptionHandler() {
  Command.globalExceptionHandler = (commandError, stackTrace) {
    final error = commandError.error;

    // Get BuildContext from navigator
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    // Handle auth errors: logout and clean up
    if (error is MenoException) {
      return;
    }

    // Handle other errors: log to crash reporter
    debugPrint('Error: $error\nStack: $stackTrace');
  };
}

void _handleMenoException(BuildContext context, MenoException exception) {
  switch (exception) {
    case Unauthenticated():
      context.showErrorSnackBar('Session expired. Please log in.');

    case ValidationException():
      context.showErrorSnackBar(exception.message);

    case NetworkException():
      context.showErrorSnackBar(exception.message);

    case TimeoutException():
      context.showErrorSnackBar(exception.message);

    case ServerException():
      context.showErrorSnackBar(exception.message);

    default:
      context.showErrorSnackBar(exception.message);
  }
}
