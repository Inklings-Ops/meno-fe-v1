import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required ISessionContext session})
      : _session = session,
        super(const AccountInitial()) {
    on<AccountInitialized>(_onInitialize);
    on<AccountSwitchRequested>(_onSwitchAccount);

    _subscription = _session.userChanges.listen((credential) {
      if (credential != null && credential.token.isValid) {
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
    return emit.forEach(
      _session.allAccounts,
      onData: (data) {
        if (data.isEmpty) return const AccountLoadSingleAccountSuccess();
        return AccountLoadSuccess(
          credential: _session.credential ?? UserCredential.empty(),
          allCredentials: data.values.toList(),
        );
      },
      onError: (error, stackTrace) {
        debugPrint('Error in AccountBloc stream: $error, $stackTrace');
        final exception = AuthExceptionWithMessage(error.toString());
        return AccountLoadFailure(exception);
      },
    );
  }

  Future<void> _onSwitchAccount(
    AccountSwitchRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoadInProgress());
    final credential = event.credential;
    final fOrS = await _session.switchAccount(credential);
    emit(
      fOrS.fold(
        AccountLoadFailure.new,
        (_) => AccountLoadSuccess(credential: credential),
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
