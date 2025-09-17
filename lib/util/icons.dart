import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/icons.dart';

MapEntry<String, PhosphorIconData>? getIconFromName(String? iconName) => icons.entries.where((element) => element.key == iconName?.toLowerCase()).toList().firstOrNull;

List<MapEntry<String, PhosphorIconData>>? getIconsFromName(String? iconName) {
  if (iconName?.isNotEmpty ?? false) {
    return icons.entries.where((element) => element.key.contains(iconName!.toLowerCase())).toList();
  }
  return icons.entries.toList();
}
