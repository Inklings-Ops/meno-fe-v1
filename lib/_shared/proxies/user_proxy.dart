import 'package:flutter/foundation.dart';
import 'package:meno/_core/value_objects/value_objects.dart';
import 'package:meno/_shared/models/user.dart';

/// Reactive proxy for the [User] entity.
final class UserProxy extends ChangeNotifier {
  UserProxy(this._user);

  User _user;

  User get user => _user;

  set user(User value) {
    if (_user != value) {
      _user = value;
      notifyListeners();
    }
  }

  Id get id => _user.id;

  String get fullName => _user.fullName.getOrElse((_) => '');

  String get email => _user.email.getOrElse((_) => '');

  String? get imageUrl => _user.image?.getUrl();

  bool get verified => _user.verified;
}
