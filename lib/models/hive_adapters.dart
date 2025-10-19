import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import 'category/category.dart';
import 'settings/settings.dart';
import 'transaction/transaction.dart';
import 'trosko_theme_tag/trosko_theme_tag.dart';

@GenerateAdapters([
  AdapterSpec<Color>(),
  AdapterSpec<Transaction>(),
  AdapterSpec<Category>(),
  AdapterSpec<Settings>(),
  AdapterSpec<TroskoThemeId>(),
])
part 'hive_adapters.g.dart';
