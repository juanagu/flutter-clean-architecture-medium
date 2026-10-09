/// The translated strings an `EmailPasswordForm` shows; the caller resolves
/// them from its own i18n keys.
class EmailPasswordFormLabels {
  const EmailPasswordFormLabels({
    required this.heading,
    required this.email,
    required this.password,
    required this.submit,
    required this.submittingSemantics,
  });

  final String heading;
  final String email;
  final String password;
  final String submit;

  /// Read by screen readers while the form is submitting.
  final String submittingSemantics;
}
