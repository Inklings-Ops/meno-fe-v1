import 'package:equatable/equatable.dart';
import 'package:meno/src/_shared/models/entities/user.dart';
import 'package:meno/src/features/auth/models/models.dart';

final class UserCredential with EquatableMixin {
  const UserCredential({required this.session, required this.user});

  final Session session;
  final User user;

  static UserCredential empty = UserCredential(
    session: Session.empty,
    user: User.empty,
  );

  @override
  List<Object?> get props => [session, user];
}
