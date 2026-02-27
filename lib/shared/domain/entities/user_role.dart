enum UserRole {
  /// Admin
  admin('admin'),

  /// Guest
  guest('guest');

  const UserRole(this.value);

  final String value;

  static UserRole fromJson(dynamic value) {
    if (value is! String) throw const FormatException('Invalid UserRole');
    return switch (value) {
      'admin' => .admin,
      'guest' => .guest,
      _ => throw Exception('Invalid user role: $value'),
    };
  }

  static String toJson(UserRole status) => status.value;
}
