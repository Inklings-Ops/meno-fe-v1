import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

final class UserCredential with EquatableMixin {
  const UserCredential({required this.token, required this.user});

  factory UserCredential.empty() {
    return UserCredential(
      token: Token(''),
      user: User(
        id: ID.empty,
        fullName: SingleLineString('New Birth Group'),
        email: Email('newbirthgroup@gmail.com'),
        bio: MultiLineString('This is a group that is committed to the growth'),
      ),
    );
  }

  final Token token;
  final User user;

  @override
  List<Object?> get props => [token, user];

  UserCredential copyWith({Token? token, User? user}) {
    return UserCredential(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  @override
  bool get stringify => true;
}

extension UserCredentialX on UserCredential {
  UserCredential get stripped {
    return UserCredential(
      user: user.stripped,
      token: token,
    );
  }
}
