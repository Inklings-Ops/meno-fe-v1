import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/exceptions/meno_exception.dart';

/// Error filter that determines how different errors should be handled.
///
/// This is used by Commands to decide whether to:
/// 1. Pass errors to local handlers (.errors stream, .fold(), await)
/// 2. Pass errors to global handler (globalExceptionHandler)
/// 3. Both
///
/// Usage:
/// ```dart
/// Command.createAsync(
///   task,
///   errorFilter: menoExceptionFilter, // Apply this filter
/// );
/// ```
ErrorReaction menoExceptionFilter(Object error, StackTrace stacktrace) {
  // Unknown Dart errors (NPE, RangeError, FormatException, etc.)
  if (error is! MenoException) {
    // Send to global handler to show error toast and log
    // Local handlers won't receive this unless they explicitly catch it
    return ErrorReaction.globalHandler;
  }

  // Route MenoException types appropriately
  return switch (error) {
    // ========================================================================
    // VALIDATION ERRORS
    // ========================================================================
    // These need BOTH local and global handling:
    // - Local: Widget shows field-level errors (red text, error messages)
    // - Global: Show toast "Please check your inputs"
    ValidationException() => ErrorReaction.localAndGlobalHandler,

    // ========================================================================
    // AUTHENTICATION ERRORS
    // ========================================================================
    // These should be handled globally:
    // - Logout user
    // - Redirect to login
    // - Show "Session expired" message
    // Local handlers don't need to know about auth failures
    Unauthenticated() => ErrorReaction.globalHandler,

    // ========================================================================
    // INFRASTRUCTURE ERRORS (Network, Server, Timeout)
    // ========================================================================
    // These are typically not actionable by individual widgets,
    // so just show a global toast.
    // Local handlers can still access via .errors if needed for specific logic
    NetworkException() => ErrorReaction.globalHandler,
    ServerException() => ErrorReaction.globalHandler,
    TimeoutException() => ErrorReaction.globalHandler,
    StorageException() => ErrorReaction.globalHandler,

    // ========================================================================
    // GENERIC MENO EXCEPTION
    // ========================================================================
    // For custom business logic errors, you might want both:
    // - Local: Widget can react (e.g., disable button)
    // - Global: Show error message to user
    //
    // If you only want global, use ErrorReaction.globalHandler
    _ => ErrorReaction.localAndGlobalHandler,
  };
}

/// Alternative filter: Global only for all errors
///
/// Use this when you want all errors to be handled globally,
/// and widgets don't need to react to errors locally.
ErrorReaction globalOnlyErrorFilter(Object error) {
  return ErrorReaction.globalHandler;
}

/// Alternative filter: Local and global for all errors
///
/// Use this when you want widgets to always have access to errors
/// AND show global error messages.
ErrorReaction localAndGlobalErrorFilter(Object error) {
  return ErrorReaction.localAndGlobalHandler;
}

/// Alternative filter: Local only for specific errors
///
/// Use this when you want complete control in the widget
/// and don't want any global error handling.
ErrorReaction localOnlyErrorFilter(Object error) {
  return ErrorReaction.localHandler;
}
