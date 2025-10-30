const notificationTriggerPackageNames = [
  'com.josipkilic.promaja',
  'com.revolut.revolut',
];

bool isNotificationFromProperPackageName({required String? packageName}) {
  if (packageName?.isEmpty ?? true) {
    return false;
  }

  for (final name in notificationTriggerPackageNames) {
    if (packageName!.contains(name)) {
      return true;
    }
  }

  return false;
}

String? getTransactionAmountFromNotification({required String? content}) {
  if (content?.isEmpty ?? true) {
    return null;
  }

  final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(content!);

  if (match == null) {
    return null;
  }

  final raw = match.group(0)!.trim().replaceAll(',', '.');

  final value = double.tryParse(raw);

  if (value == null) {
    return null;
  }

  return value.toStringAsFixed(2);
}
