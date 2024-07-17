import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

part 'account_event.dart';
part 'account_state.dart';
part 'account_bloc.freezed.dart';

@lazySingleton
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final IAuthFacade _facade;
  AccountBloc({required IAuthFacade facade})
      : _facade = facade,
        super(const _AccountInitial()) {
    on<AccountInitialized>(_onInitialize);
    on<AccountSwitchRequested>(_onSwitchAccount);
  }
  void init() => add(const AccountInitialized());
  Future<void> _onInitialize(AccountInitialized event, emit) async {
    emit(const AccountLoading());
    final allCredentials = await _getAllCredentials();
    final credential = _facade.credential!;
    emit(AccountLoadSuccess(
      currentCredential: credential,
      allCredentials: allCredentials,
    ));
  }

  Future<void> _onSwitchAccount(AccountSwitchRequested event, emit) async {
    final allCredentials = (state as AccountLoadSuccess).allCredentials;
    emit(const AccountLoading());
    final fOrS = await _facade.switchAccount(event.credential);
    emit(fOrS.fold(
      (f) => AccountLoadFailure(f),
      (r) => AccountLoadSuccess(
        currentCredential: event.credential,
        allCredentials: allCredentials,
      ),
    ));
  }

  Future<List<UserCredential>> _getAllCredentials() async {
    final credentialsMap = await _facade.allCredentials;
    return credentialsMap?.values.toList() ?? [];
  }
}
