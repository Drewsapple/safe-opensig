// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SafeAccountAdapter extends TypeAdapter<SafeAccount> {
  @override
  final typeId = 2;

  @override
  SafeAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SafeAccount(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      chainId: (fields[6] as num).toInt(),
      version: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SafeAccount obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.version)
      ..writeByte(6)
      ..write(obj.chainId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafeAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
