import 'package:equatable/equatable.dart';
import 'package:meno/_shared/models/user.dart';
import 'package:meno/features/auth/models/value_objects/session.dart';

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

extension UserCredX on UserCredential {
  bool get isEmpty => this == .empty;
}
