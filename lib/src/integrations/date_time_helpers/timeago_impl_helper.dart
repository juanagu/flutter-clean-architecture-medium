import 'package:app/src/core/presentation/helpers/time_ago_helper.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeagoImplHelper implements TimeagoHelper {
  @override
  String format(DateTime dateTime) {
    if (dateTime == null) return '';
    return timeago.format(dateTime);
  }
}
