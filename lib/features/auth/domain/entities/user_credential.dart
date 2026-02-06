import 'package:equatable/equatable.dart';
import 'package:meno/features/auth/domain/entities/session.dart';
import 'package:meno/shared/domain/entities/user.dart';

final class UserCredential with EquatableMixin {
  const UserCredential({required this.session, required this.user});

  final Session session;
  final User user;

  @override
  List<Object?> get props => [session, user];
}
