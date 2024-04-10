part of 'account_cubit.dart';

// This class represents the state of the account management feature.
@freezed
class AccountState with _$AccountState {
  /// Creates an instance of [AccountState] with the provided properties.
  const factory AccountState({
    /// A list of all available user credentials.
    required List<UserCredential> allCredentials,

    /// The currently selected user credentials.
    required UserCredential currentCredential,

    /// Indicates whether the account feature is currently loading data.
    required bool loading,

    /// Represents the result of an account-related operation, either a
    /// successful value (Unit) or an error (AuthException).
    required Option<Either<AuthException, Unit>> option,
  }) = _AccountState;

  /// Creates an empty state with default values.
  factory AccountState.empty() {
    return AccountState(
      allCredentials: [],
      currentCredential: UserCredential.empty(),
      loading: false,
      option: none(),
    );
  }
}
