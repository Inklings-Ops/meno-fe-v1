enum UserDisplay {
  system('system'),
  dark('dark'),
  light('light');

  const UserDisplay(this.value);

  final String value;

  static UserDisplay fromString(String value) {
    return UserDisplay.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserDisplay.system,
    );
  }
}
