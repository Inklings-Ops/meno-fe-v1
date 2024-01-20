import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final IAuthFacade _facade;

  late final StreamSubscription<User?> _userSubscription;
  late final StreamSubscription<UserToken?> _tokenSubscription;

  AuthBloc({required IAuthFacade facade})
      : _facade = facade,
        super(AuthState.empty()) {
    on<_AuthUserChanged>(_onUserChanged);
    on<_AuthTokenChanged>(_onTokenChanged);
    on<_AuthLogoutRequested>(_onLogoutRequested);

    _userSubscription = _facade.userChanges.listen(
      (user) => add(_AuthUserChanged(user: user)),
    );

    _tokenSubscription = _facade.tokenChanges.listen(
      (token) => add(_AuthTokenChanged(token: token)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _tokenSubscription.cancel();
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final userDto = json['user'] as UserDto?;
    final user = AuthMapper().userToDomain(userDto);
    return AuthState.empty().copyWith(user: user);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    final userDto = AuthMapper().userToDto(state.user);
    return {'user': userDto?.toJson()};
  }

  void _onLogoutRequested(_AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_facade.logout());
  }

  void _onTokenChanged(_AuthTokenChanged event, Emitter<AuthState> emit) {
    if (event.token != null) {
      emit(state.copyWith(token: event.token));
    } else {
      emit(state.copyWith(
        token: null,
        status: AuthStatus.partiallyAuthenticated,
      ));
    }
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(state.copyWith(user: event.user, status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(user: null, status: AuthStatus.unauthenticated));
    }
  }
}
