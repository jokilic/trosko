import 'package:easy_localization/easy_localization.dart';

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String getGreeting(DateTime dateTime) => switch (dateTime.hour) {
  >= 5 && < 12 => 'greetingMorning'.tr(),
  >= 12 && < 17 => 'greetingAfternoon'.tr(),
  >= 17 && < 22 => 'greetingEvening'.tr(),
  _ => 'greetingNight'.tr(),
};
