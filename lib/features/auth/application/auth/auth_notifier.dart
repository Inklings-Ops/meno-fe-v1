import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';

enum AuthState {
  authenticated,
  partiallyAuthenticated,
  unauthenticated,
}

@Injectable()
class AuthNotifier extends ChangeNotifier {
  final IAuthFacade facade;

  AuthState _state = AuthState.unauthenticated;

  User _user = User.empty();

  UserToken? _token;

  Map<String, UserCredentials> _allCredentials = {};

  Option<Either<AuthException, Unit>> _option = none();

  bool _loading = false;

  AuthNotifier({required this.facade});

  Map<String, UserCredentials> get allCredentials => _allCredentials;
  set allCredentials(Map<String, UserCredentials> value) {
    _allCredentials = value;
    notifyListeners();
  }

  AuthState get state => _state;
  set state(AuthState value) {
    _state = value;
    notifyListeners();
  }

  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  UserToken? get token => _token;
  set token(UserToken? value) {
    _token = value;
    notifyListeners();
  }

  Option<Either<AuthException, Unit>> get option => _option;
  set option(Option<Either<AuthException, Unit>> value) {
    _option = value;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> changeUser(UserCredentials credentials) async {
    loading = true;
    final result = await facade.changeUser(credentials);
    option = some(result);
    await checkAuthenticated();
    loading = false;
    // notifyListeners();
  }

  @PostConstruct(preResolve: true)
  Future<void> checkAuthenticated() async {
    final bool isAuthenticated = await facade.isAuthenticated;
    final bool isPartiallyAuthenticated = await facade.isPartiallyAuthenticated;

    final User? currentUser = await facade.user;
    final UserToken? currentToken = await facade.userToken;
    final Map<String, UserCredentials>? credentials =
        await facade.getAllUserCredentials();

    if (isPartiallyAuthenticated) {
      state = AuthState.partiallyAuthenticated;
      user = currentUser!;
      allCredentials = credentials!;
    }

    if (isAuthenticated) {
      state = AuthState.authenticated;
      user = currentUser!;
      token = currentToken;
      allCredentials = credentials!;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    loading = true;
    state = AuthState.unauthenticated;
    user = User.empty();
    token = null;
    await facade.logout();
    loading = false;
    notifyListeners();
  }

  Future<void> partialLogout() async {
    loading = true;
    state = AuthState.authenticated;
    token = null;
    await facade.partialLogout();
    loading = false;
    notifyListeners();
  }
}
