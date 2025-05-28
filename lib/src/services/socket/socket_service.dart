import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/core/exceptions/socket_exception.dart';
import 'package:meno_fe_v1/src/shared/session/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@injectable
class SocketService {
  SocketService({required ISessionContext session}) : _session = session;
  final ISessionContext _session;

  io.Socket? _socket;
  StreamSubscription? _authSubscription;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    _authSubscription = _session.userChanges.listen((credential) async {
      if (credential != null) {
        final token = credential.token;
        if (token.isValid) {
          // Connect only if not already connected or trying to connect
          if (_socket == null || _socket?.connected == false) {
            log('SocketService: User authenticated, connecting with token...');
            await connect(token: token.getOrCrash());
          }
        } else {
          log('SocketService: No authentication token found. Cannot connect.');
          disconnect();
        }
      } else {
        log('SocketService: User logged out, disconnecting...');
        disconnect();
      }
    });

    // // Handle initial state: if already logged in when service initializes
    final initialCredential = _session.credential;
    if (initialCredential != null) {
      final token = initialCredential.token;
      if (token.isValid) {
        log('SocketService: Authenticated, connecting with token...');
        await connect(token: token.getOrCrash());
      }
    }
  }

  bool get isSocketConnected => _socket?.connected ?? false;

  Future<void> connect({required String token}) async {
    if (_socket?.connected ?? false) return;

    _socket?.dispose();

    _socket = io.io(
      Env.menoApiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _setupListeners();
  }

  /// Emits an event and waits for an acknowledgment from the server.
  ///
  /// Returns a Future that completes with the acknowledgment data from the
  /// server.
  ///
  /// The Future will complete with an error if:
  /// - The socket is not connected.
  /// - An error occurs during the emit process locally.
  /// - The acknowledgment times out (if timeout is provided).
  ///
  /// The acknowledgment data itself might contain an error indicator
  /// from the server (e.g., {'error': 'Something went wrong'}), which
  /// needs to be checked by the caller.
  ///
  Future<dynamic> emit(String event, dynamic data) async {
    // Use Completer<dynamic> to hold the ack response data
    final completer = Completer<dynamic>();

    // // Check connection state BEFORE creating the completer
    if (!isSocketConnected) {
      // Throw an exception that can be caught by the caller
      log('Emit failed: Socket not connected.');
      return completer.completeError(
        const SocketException('Socket not connected'),
      );
    } else {
      try {
        log('Emitting event: $event');

        // The ack function provided to the socket.io client
        // will complete our completer with the server response.
        void ackWrapper(dynamic response) {
          log('Received ack for event $event: $response');
          if (!completer.isCompleted) completer.complete(response);
        }

        _socket!.emitWithAck(event, data, ack: ackWrapper);

        // Return the future that will complete with the ack response or error
        return completer.future;
      } on Exception catch (e) {
        log('Error emitting event $event: $e');

        // Ensure completer fails if it hasn't already
        if (!completer.isCompleted) {
          completer.completeError(e);
        }

        // Rethrow or throw a specific exception if needed
        throw SocketException('Failed to emit event $event: $e');
      }
    }
  }

  dynamic onConnect(dynamic Function(dynamic) handler) {
    return _socket?.onConnect(handler);
  }

  dynamic onDisconnect(dynamic Function(dynamic) handler) {
    return _socket?.onDisconnect(handler);
  }

  dynamic onReconnect(dynamic Function(dynamic) handler) {
    return _socket?.onReconnect(handler);
  }

  dynamic onReconnectAttempt(dynamic Function(dynamic) handler) {
    return _socket?.onReconnectAttempt(handler);
  }

  void _setupListeners() {
    _socket?.onConnect((data) => log('Socket connected, $data'));
    _socket?.onDisconnect((data) => log('Socket disconnected, $data'));
    _socket?.onReconnect((data) => log('Socket reconnecting, $data'));
    _socket?.onReconnectAttempt((data) => log('Socket reconnecting, $data'));
  }

  // Method for feature providers to add their listeners
  void addListener(String event, dynamic Function(dynamic) handler) {
    if (_socket == null) {
      log('Warning: Socket not initialized, cannot add listener for $event');
      return;
    }
    _socket?.on(event, handler);
  }

  // Method for feature providers to remove their listeners
  void removeListener(String event, [dynamic Function(dynamic)? handler]) {
    if (_socket == null) {
      log('Warning: Socket not initialized, cannot remove listener for $event');
      return;
    }
    // Providing the specific handler is safer if multiple listeners exist
    // for the same event
    if (handler != null) {
      _socket!.off(event, handler);
    } else {
      _socket!.off(event);
    }
  }

  void disconnect() {
    if (_socket == null || (_socket?.connected ?? false)) return;

    log('Socket disconnecting...');
    _socket?.dispose();
    _socket = null;
    log('Socket disconnected successfully.');
  }

  Future<void> dispose() async {
    log('SocketService: Disposing.');
    await _authSubscription?.cancel();
    _authSubscription = null;
    _socket?.dispose();
  }

  SocketException getErrorMessage(dynamic error) {
    final result = switch (error) {
      final Map<String, dynamic> errors => SocketValidationException(errors),
      _ => SocketException(error),
    };
    return result;
  }
}
