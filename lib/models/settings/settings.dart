import 'package:flutter/material.dart';

class Settings {
  final bool isLoggedIn;

  final int themeModeInt;

  final Color? primaryColor;

  Settings({
    required this.isLoggedIn,
    required this.themeModeInt,
    required this.primaryColor,
  });

  Settings copyWith({
    bool? isLoggedIn,
    int? themeModeInt,
    Color? primaryColor,
    String? languageLocale,
  }) => Settings(
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    themeModeInt: themeModeInt ?? this.themeModeInt,
    primaryColor: primaryColor ?? this.primaryColor,
  );

  @override
  String toString() => 'Settings(isLoggedIn: $isLoggedIn, themeModeInt: $themeModeInt, primaryColor: $primaryColor)';

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.isLoggedIn == isLoggedIn && other.themeModeInt == themeModeInt && other.primaryColor == primaryColor;
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ themeModeInt.hashCode ^ primaryColor.hashCode;
}
