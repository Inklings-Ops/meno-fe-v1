import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/exceptions/meno_exception.dart';
import 'package:meno/_core/keys/meno_keys.dart';
import 'package:meno/_shared/widgets/extensions/m_snack_bar_extension.dart';

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
    final error = commandError.error;

    debugPrint('┌─────────────────────────────────────────────────────────');
    debugPrint('│ Global Error Handler');
    debugPrint('│ Error: $error');
    debugPrint('│ Stack: $stackTrace');
    debugPrint('└─────────────────────────────────────────────────────────');

    // Get current BuildContext from navigator
    final context = MenoKeys.scaffoldMessengerKey.currentContext;
    if (context == null) {
      debugPrint('⚠️ Cannot show error: No BuildContext available');
      return;
    }

    // Handle different error types
    if (error is MenoException) {
      _handleMenoException(context, error);
    } else {
      // Handle unknown Dart errors (NPE, RangeError, etc.)
      _handleUnknownError(context, error);
    }
  };
}

/// Handles MenoException errors with appropriate UI feedback
void _handleMenoException(BuildContext context, MenoException exception) {
  switch (exception) {
    // Authentication errors - logout and show message
    case Unauthenticated():
      _handleUnauthenticated(context, exception);

    // Validation errors - show field-level errors
    case ValidationException():
      context.showErrorSnackBar(exception.message);

    // Network/Infrastructure errors - show error snack bar
    case NetworkException():
      context.showErrorSnackBar('No internet connection');

    case TimeoutException():
      context.showErrorSnackBar('Request timed out. Please try again.');

    case ServerException():
      context.showErrorSnackBar(
        exception.message.isEmpty ? 'Server error occurred' : exception.message,
      );

    case StorageException():
      context.showErrorSnackBar(
        exception.message.isEmpty
            ? 'Storage error occurred'
            : exception.message,
      );

    // Generic MenoException
    default:
      context.showErrorSnackBar(
        exception.message.isEmpty ? 'An error occurred' : exception.message,
      );
  }
}

/// Handles authentication errors
void _handleUnauthenticated(BuildContext context, Unauthenticated error) {
  // Show error message
  context.showErrorSnackBar('Your session has expired. Please log in again.');

  // Logout user
  // Note: You'll need to implement this based on your auth setup
  // Example:
  // final authManager = di<AuthManager>();
  // authManager.logout.run();

  // Optionally redirect to login
  // Example with go_router:
  // context.go('/login');
}

/// Handles unknown/unexpected errors
void _handleUnknownError(BuildContext context, Object error) {
  debugPrint('⚠️ Unknown error: $error');

  // Show generic error message
  context.showErrorSnackBar('An unexpected error occurred');

  // Log to crash reporting service (Sentry, Firebase Crashlytics, etc.)
  // logToCrashReporter(error, stackTrace);
}
