import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

part 'account_bloc.freezed.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required ISessionContext session})
      : _session = session,
        super(AccountState.initial()) {
    on<AccountInitialized>(_onInitialize);
    on<AccountSwitchRequested>(_onSwitchAccount);

    _subscription = _session.userChanges.listen((credential) {
      if (credential != null && (credential.token?.isValid ?? false)) {
        add(const AccountInitialized());
      }
    });
  }

  final ISessionContext _session;

  StreamSubscription<UserCredential?>? _subscription;

  Future<void> _onInitialize(
    AccountInitialized event,
    Emitter<AccountState> emit,
  ) async {
    final allCreds = await _session.allCredentials;
    final cred = _session.credential ?? UserCredential.empty();
    if (allCreds.isNotEmpty && allCreds.length > 1) {
      emit(AccountLoaded(allCredentials: allCreds, credential: cred));
    } else {
      emit(const SingleAccountLoaded());
    }
  }

  Future<void> _onSwitchAccount(
    AccountSwitchRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    final fOrS = await _session.switchAccount(event.credential);
    emit(
      fOrS.fold(
        AccountFailure.new,
        (credential) => AccountLoaded(credential: credential),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
