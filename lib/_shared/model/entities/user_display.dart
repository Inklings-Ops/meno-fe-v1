enum UserDisplay {
  system('system'),
  dark('dark'),
  light('light');

  const UserDisplay(this.value);

  final String value;

  static UserDisplay fromJson(dynamic value) {
    if (value is! String) throw Exception('Expected string');
    return UserDisplay.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserDisplay.system,
    );
  }
}
