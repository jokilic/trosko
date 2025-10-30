const notificationTriggerPackageNames = [
  'com.josipkilic.promaja',
  'com.google.android.apps.wallet',
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

double? getTransactionAmountFromNotification({
  required String? title,
  required String? content,
}) {
  final searchableText = '${title ?? ''} ${content ?? ''}';
  final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(searchableText);

  if (match == null) {
    return null;
  }

  final raw = match.group(0)!.trim().replaceAll(',', '.');

  return double.tryParse(raw);
}
