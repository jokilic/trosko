import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/phosphor_icons.dart';

///
/// HELPERS
///

/// Returns the appropriate [PhosphorIconData]
PhosphorIconData getPhosphorIcon(
  PhosphorIconData Function([PhosphorIconsStyle]) icon, {
  required bool isDuotone,
  required bool isBold,
}) {
  if (isDuotone) {
    return icon(
      PhosphorIconsStyle.duotone,
    );
  }

  if (isBold) {
    return icon(
      PhosphorIconsStyle.bold,
    );
  }

  return icon();
}

MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])>? getPhosphorIconFromName(String? iconName) =>
    phosphorIcons.entries.where((element) => element.key == iconName?.toLowerCase()).toList().firstOrNull;

List<MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])>>? getPhosphorIconsFromName(String? iconName) {
  if (iconName?.isNotEmpty ?? false) {
    return phosphorIcons.entries.where((element) => element.key.contains(iconName!.toLowerCase())).toList();
  }
  return phosphorIcons.entries.toList();
}
