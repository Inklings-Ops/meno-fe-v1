// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:injectable/injectable.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../../core/isolates/m_isolates.dart';
// import '../../../../dependency_injector/injector.dart';
// import '../../domain/domain.dart';

// part 'auth_notifier.freezed.dart';
// part 'auth_notifier.g.dart';
// part 'auth_state.dart';

// @riverpod
// List<UserCredentials> allCredentials(AllCredentialsRef ref) {
//   return ref.watch(authProvider).credentials.values.toList();
// }

// @riverpod
// IAuthFacade authFacade(AuthFacadeRef ref) => di<IAuthFacade>();

// @riverpod
// bool hasOneAccount(HasOneAccountRef ref) {
//   return ref.watch(allCredentialsProvider).length == 1;
// }

// @riverpod
// User user(UserRef ref) => ref.watch(authProvider).user ?? User.empty();

// @riverpod
// UserToken? userToken(UserTokenRef ref) => ref.watch(authProvider).token;

// final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
//   return di<AuthNotifier>();
// });

// @Injectable()
// class AuthNotifier extends ChangeNotifier {
//   final IAuthFacade _facade;
//   AuthNotifier(this._facade);

//   bool _loading = false;
//   bool get loading => _loading;

//   AuthStatus _status = AuthStatus.unauthenticated;
//   AuthStatus get status => _status;

//   User? _user;
//   User? get user => _user;

//   UserToken? _token;
//   UserToken? get token => _token;

//   Map<String, UserCredentials> _credentials = {};
//   Map<String, UserCredentials> get credentials => _credentials;

//   Option<Either<AuthException, dynamic>> _option = none();
//   Option<Either<AuthException, dynamic>> get option => _option;

//   @PostConstruct(preResolve: true)
//   Future<void> checkAuthenticated() async {
//     final rootIsolateToken = RootIsolateToken.instance!;
//     final results = await MIsolates.authResult(rootIsolateToken);

//     _user = results[0] as User?;
//     _token = results[1] as UserToken?;
//     _credentials = (results[2] as Map<String, UserCredentials>?) ?? {};

//     final isPartiallyAuthenticated = (_token == null) && (_user != null);
//     final isAuthenticated = (_token != null) && (_user != null);

//     if (isAuthenticated) {
//       _status = AuthStatus.authenticated;
//       notifyListeners();
//     } else if (isPartiallyAuthenticated) {
//       _status = AuthStatus.partiallyAuthenticated;
//       notifyListeners();
//     } else {
//       _status = AuthStatus.partiallyAuthenticated;
//       notifyListeners();
//     }
//   }

//   /// Logs the user out and resets the authentication state to initial.
//   Future<void> logout() async {
//     _status = AuthStatus.unauthenticated;
//     _token = null;
//     _user = null;
//     notifyListeners();
//     await _facade.logout();
//   }

//   /// Performs a partial logout by clearing the token and keeping the user data.
//   Future<void> partialLogout() async {
//     _status = AuthStatus.partiallyAuthenticated;
//     _token = null;
//     notifyListeners();
//     await _facade.partialLogout();
//   }

//   /// Switches the user account and updates the authentication state.
//   Future<void> switchAccount(UserCredentials credentials) async {
//     _loading = true;
//     _option = none();
//     notifyListeners();

//     final result = await _facade.switchAccount(credentials);

//     result.fold(
//       (l) {
//         _loading = false;
//         _option = some(result);
//         notifyListeners();
//       },
//       (r) {
//         _loading = false;
//         _option = some(result);
//         _status = AuthStatus.authenticated;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> login({
//     required IEmail email,
//     required IPassword password,
//   }) async {
//     /// Checks if the email and password are valid.
//     final isEmailValid = email.isValid();
//     final isPasswordValid = password.get() != null;

//     /// If the email and password are valid, attempts to log the user in.
//     if (isEmailValid && isPasswordValid) {
//       /// Updates the state to indicate that the login process is in progress.
//       _loading = true;
//       _option = none();

//       /// Calls the `login()` method on the `_authFacade` object to attempt to log the user in.
//       final result = await _facade.login(email: email, password: password);

//       result.fold(
//         (l) {
//           _loading = false;
//           _option = some(result);
//         },
//         (r) async => await checkAuthenticated(),
//       );
//     }
//   }
// }

// /// Enumeration representing different authentication status.
// enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
