// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemsDataAdapter extends TypeAdapter<ItemsData> {
  @override
  final int typeId = 1;

  @override
  ItemsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemsData(
      name: fields[0] as String,
      url: fields[1] as String,
      detail: fields[2] as String,
      price: fields[3] as double,
      favourite: fields[4] as bool,
      itemCount: fields[5] as int,
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemsData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.detail)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.favourite)
      ..writeByte(5)
      ..write(obj.itemCount)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
