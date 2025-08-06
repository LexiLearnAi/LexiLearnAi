import 'package:easy_localization/easy_localization.dart';

extension FormatDate on DateTime {
  String getDayString() {
    return DateFormat("EEEE").format(this);
  }

  String getDateString() {
    return DateFormat("dd/MM/y").format(this);
  }
}
