import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:logger/logger.dart';
import 'package:meno/_core/exceptions/meno_exception.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';

/// Sets up the global exception handler for all Commands.
///
/// This handler:
/// 1. Shows appropriate snack bars for different error types
/// 2. Handles authentication errors (logout/redirect)
/// 3. Logs errors for debugging
///
/// Must be called in main() before runApp().
void configureGlobalExceptionHandler() {
  Command.globalExceptionHandler = (commandError, stackTrace) {
    final logger = di<Logger>();
    final interaction = di<InteractionManager>();

    final error = commandError.error;

    logger.e('Global Error Handler', error: error, stackTrace: stackTrace);

    switch (error) {
      case ValidationException():
        // Handled locally — no toast needed
        break;
      case Unauthenticated():
        interaction.showErrorSnackBar('Session has expired. Please log in.');
        di<AuthManager>().logout.run();
      case NetworkException():
        interaction.showErrorSnackBar('No internet connection');
      case TimeoutException():
        interaction.showErrorSnackBar('Request timed out. Please try again.');
      case ServerException():
        interaction.showErrorSnackBar(
          error.message.isEmpty ? 'Server error occurred' : error.message,
        );
      case StorageException():
        interaction.showErrorSnackBar(
          error.message.isEmpty ? 'Storage error occurred' : error.message,
        );
      case MenoException():
        interaction.showErrorSnackBar(
          error.message.isEmpty ? 'An error occurred' : error.message,
        );
      default:
        debugPrint('⚠️ Unknown error type: ${error.runtimeType}');
        interaction.showErrorSnackBar('An unexpected error occurred');
    }
  };
}
