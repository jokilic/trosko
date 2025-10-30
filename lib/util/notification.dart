import 'package:flutter/foundation.dart';

const notificationTriggerPackageNames = [
  'com.josipkilic.promaja',
  'com.google.android.apps.wallet',
];

bool isNotificationFromProperPackageName({required String? packageName}) {
  // TODO: Remove this
  if (kDebugMode) {
    return packageName != 'com.josipkilic.trosko';
  }

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

String? getTransactionAmountFromNotification({
  required String? title,
  required String? content,
}) {
  final searchableText = '${title ?? ''} ${content ?? ''}';
  final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(searchableText);

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
