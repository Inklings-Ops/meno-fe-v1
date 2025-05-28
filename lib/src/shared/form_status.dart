/// Enum representing the submission status of a form.
enum FormStatus {
  /// The form has not yet been submitted.
  initial,

  /// The form is in the process of being submitted.
  loading,

  /// The form has been submitted successfully.
  success,

  /// The form submission failed.
  failure,

  /// The form submission has been canceled.
  canceled,
}

extension FormStatusX on FormStatus {
  bool get isInitial => this == FormStatus.initial;
  bool get isLoading => this == FormStatus.loading;
  bool get isSuccess => this == FormStatus.success;
  bool get isFailure => this == FormStatus.failure;
  bool get isCanceled => this == FormStatus.canceled;
}
