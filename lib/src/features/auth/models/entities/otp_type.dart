enum OtpType {
  emailVerification('email_verification'),
  passwordReset('password_reset');

  const OtpType(this.value);

  final String value;
}
