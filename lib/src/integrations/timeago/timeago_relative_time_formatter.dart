import 'package:app/src/core/presentation/formatters/relative_time_formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeagoRelativeTimeFormatter implements RelativeTimeFormatter {
  TimeagoRelativeTimeFormatter() {
    timeago.setLocaleMessages('es', timeago.EsMessages());
  }

  @override
  String format(DateTime dateTime, {required String languageCode}) =>
      timeago.format(dateTime, locale: languageCode);
}
