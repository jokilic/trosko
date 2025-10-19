// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trosko_theme_tag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TroskoThemeIdAdapter extends TypeAdapter<TroskoThemeId> {
  @override
  final typeId = 3;

  @override
  TroskoThemeId read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TroskoThemeId.light;
      case 1:
        return TroskoThemeId.dark;
      default:
        return TroskoThemeId.light;
    }
  }

  @override
  void write(BinaryWriter writer, TroskoThemeId obj) {
    switch (obj) {
      case TroskoThemeId.light:
        writer.writeByte(0);
      case TroskoThemeId.dark:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TroskoThemeIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
