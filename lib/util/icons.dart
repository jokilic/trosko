import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/icons_bold.dart';
import '../constants/icons_regular.dart';
import '../constants/icons_thin.dart';

///
/// REGULAR ICONS
///

MapEntry<String, PhosphorIconData>? getRegularIconFromName(String? iconName) =>
    iconsRegular.entries.where((element) => element.key == iconName?.toLowerCase()).toList().firstOrNull;

List<MapEntry<String, PhosphorIconData>>? getRegularIconsFromName(String? iconName) {
  if (iconName?.isNotEmpty ?? false) {
    return iconsRegular.entries.where((element) => element.key.contains(iconName!.toLowerCase())).toList();
  }
  return iconsRegular.entries.toList();
}

///
/// BOLD ICONS
///

MapEntry<String, PhosphorIconData>? getBoldIconFromName(String? iconName) => iconsBold.entries.where((element) => element.key == iconName?.toLowerCase()).toList().firstOrNull;

///
/// THIN ICONS
///

MapEntry<String, PhosphorIconData>? getThinIconFromName(String? iconName) => iconsThin.entries.where((element) => element.key == iconName?.toLowerCase()).toList().firstOrNull;
