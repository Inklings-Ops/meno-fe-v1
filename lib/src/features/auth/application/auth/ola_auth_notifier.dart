// @riverpod
// IAuthFacade authFacade(AuthFacadeRef ref) => di<IAuthFacade>();

// /// Provider that retrieves a list of all user credentials.
// final allCredentialsProvider = Provider(
//   (ref) => ref.watch(authProvider).credentials.values.toList(),
// );

// /// Provider that manages the authentication state.
// // final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
// //   (ref) => di<Auth>(),
// // );

// final authProvider = ChangeNotifierProvider<Auth>((ref) {
//   return Auth(ref.read(authFacadeProvider));
// });

// /// Provider that checks if the user has only one account.
// final hasOneAccountProvider = Provider(
//   (ref) => ref.watch(allCredentialsProvider).length == 1,
// );

// /// Provider that retrieves the user data from the authentication state.
// final userProvider = Provider((ref) => ref.watch(authProvider).user);

// /// Provider that retrieves the user token from the authentication state.
// final userTokenProvider = Provider((ref) => ref.watch(authProvider).token);

// @Injectable()
// class AuthNotifier extends StateNotifier<AuthState> {
//   final IAuthFacade _facade;

//   AuthNotifier(this._facade) : super(AuthState.initial());

//   /// Checks the authentication status and updates the state accordingly.
//   @PostConstruct(preResolve: true)
  // Future<void> checkAuthenticated() async {
  //   RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  //   final List<dynamic> results = await MIsolates.authResult(rootIsolateToken);

  //   final User currentUser = results[0] ?? User.empty();
  //   final UserToken? currentToken = results[1] as UserToken?;
  //   final Map<String, UserCredentials> credentials = results[2] ?? {};

  //   final isPartiallyAuthenticated = await _facade.isPartiallyAuthenticated;
  //   final isAuthenticated = await _facade.isAuthenticated;

  //   AuthStatus status = AuthStatus.unauthenticated;
  //   UserToken? token;

  //   if (isAuthenticated) {
  //     status = AuthStatus.authenticated;
  //     token = currentToken;
  //   } else if (isPartiallyAuthenticated) {
  //     status = AuthStatus.partiallyAuthenticated;
  //   }

  //   state = state.copyWith(
  //     status: status,
  //     user: currentUser,
  //     credentials: credentials,
  //     token: token,
  //   );
  // }

  /// Logs the user out and resets the authentication state to initial.
  // Future<void> logout() async {
  //   await _facade.logout();
  //   state = AuthState.initial();
  // }

  // /// Performs a partial logout by clearing the token and keeping the user data.
  // Future<void> partialLogout() async {
  //   await _facade.partialLogout();
  //   state = state.copyWith(token: "");
  // }

//   /// Switches the user account and updates the authentication state.
//   Future<void> switchAccount(UserCredentials credentials) async {
//     state = state.copyWith(loading: true, option: none());

//     final result = await _facade.switchAccount(credentials);

//     state = state.copyWith(
//       loading: false,
//       option: some(result),
//       status: AuthStatus.authenticated,
//       user: credentials.user,
//       token: credentials.token!,
//     );
//   }
// }

/// Enumeration representing different authentication status.
// enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
