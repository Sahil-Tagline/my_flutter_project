import 'package:hive/hive.dart';

part 'hive_model.g.dart';

@HiveType(typeId: 1)
class ItemsData extends HiveObject{

  ItemsData({required this.name, required this.url, required this.detail, required this.price,
    required this.favourite, required this.itemCount, required this.category});

  @HiveField(0)
  String name;

  @HiveField(1)
  String url;

  @HiveField(2)
  String detail;

  @HiveField(3)
  double price;

  @HiveField(4)
  bool favourite;

  @HiveField(5)
  int itemCount;

  @HiveField(6)
  String category;



}