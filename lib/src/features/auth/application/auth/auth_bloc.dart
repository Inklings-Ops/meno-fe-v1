// import 'dart:async';

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:injectable/injectable.dart';

// import '../../../onboarding/onboarding.dart';
// import '../../domain/domain.dart';

// part 'auth_bloc.freezed.dart';
// part 'auth_event.dart';
// part 'auth_state.dart';

// /// Manages authentication state and events using the BLoC pattern.
// ///
// /// Registers as a singleton using the `@lazySingleton` annotation.
// @lazySingleton
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   /// Authentication facade for interacting with authentication services.
//   final IAuthFacade _facade;

//   /// Onboarding facade for checking onboarding status.
//   final IOnboardingFacade _onboardingFacade;

//   /// Subscription to the user credential stream from the authentication facade.
//   late final StreamSubscription<UserCredential?> _userSubscription;

//   /// Creates a new instance of the AuthBloc.
//   ///
//   /// Injects necessary dependencies for authentication and onboarding.
//   AuthBloc({
//     required IAuthFacade facade,
//     required IOnboardingFacade onboardingFacade,
//   })  : _facade = facade,
//         _onboardingFacade = onboardingFacade,
//         super(const AuthState.unauthenticated()) {
//     // Register event handlers
//     on<AuthChanged>(_onUserChanged);
//     on<AuthLogoutRequested>(_onLogoutRequested);

//     // Initializes the authentication facade by retrieving the user's
//     // credentials stored in the secure local storage
//     _facade.init();

//     // Subscribe to user credential changes
//     _userSubscription = _facade.userChanges.listen(
//       (credentials) => add(AuthChanged(credentials: credentials)),
//     );
//   }

//   /// Closes the bloc, releasing resources and canceling subscriptions.
//   @override
//   Future<void> close() {
//     _userSubscription.cancel();
//     return super.close();
//   }

//   /// Handles the logout request event.
//   void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
//     // Log out using the authentication facade
//     unawaited(_facade.logout());
//   }

//   /// Handles the authentication changed event.
//   void _onUserChanged(AuthChanged event, Emitter<AuthState> emit) {
//     // Skip processing if onboarding is not complete
//     if (!_onboardingFacade.isOnboarded) return;

//     final credentials = event.credentials;

//     if (credentials == null) {
//       // Emit unauthenticated state if credentials are null
//       return emit(const AuthState.unauthenticated());
//     }

//     if (!credentials.token!.isActive) {
//       // Emit partially authenticated state if token is expired
//       return emit(AuthState.partiallyAuthenticated(credentials));
//     }

//     // Emit authenticated state if credentials are valid
//     return emit(AuthState.authenticated(credentials));
//   }
// }
