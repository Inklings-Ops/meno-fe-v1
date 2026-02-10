import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';

ErrorReaction menoExceptionFilter(Object error, StackTrace stackTrace) {
  if (error is! MenoException) return ErrorReaction.globalHandler;

  return switch (error) {
    // Validation: Both local (field errors) and global (toast)
    ValidationException() => ErrorReaction.localAndGlobalHandler,

    // Auth: Global only (logout + redirect)
    Unauthenticated() => ErrorReaction.globalHandler,

    // Infrastructure: Global only (show toast)
    NetworkException() => ErrorReaction.globalHandler,
    ServerException() => ErrorReaction.globalHandler,
    TimeoutException() => ErrorReaction.globalHandler,

    // Default: Both handlers
    _ => ErrorReaction.localAndGlobalHandler,
  };
}
