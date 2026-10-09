/// Formats an instant as a relative phrase such as "5 minutes ago", in the
/// language of [languageCode].
abstract class RelativeTimeFormatter {
  String format(DateTime dateTime, {required String languageCode});
}
