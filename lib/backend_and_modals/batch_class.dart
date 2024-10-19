import 'package:hive/hive.dart';
part 'batch_class.g.dart';

@HiveType(typeId: 0, adapterName: 'ClassAdapter')
class ClassDetails {
  @HiveField(0)
  String cw;

  @HiveField(1)
  String hw;

  @HiveField(2)
  String offlineExam;

  @HiveField(3)
  String onlineExam;

  @HiveField(4)
  DateTime createdAt;

  ClassDetails({
    required this.cw,
    required this.hw,
    required this.offlineExam,
    required this.onlineExam,
    required this.createdAt,
  });
}

@HiveType(typeId: 1, adapterName: 'BatchAdapter')
class Batch {
  @HiveField(0)
  String nameLowerCase;

  @HiveField(1)
  String database;

  @HiveField(2)
  String name;

  @HiveField(3)
  List<int> days;

  @HiveField(4)
  int clasS;

  @HiveField(5)
  DateTime classDateTime;

  Batch({
    required this.nameLowerCase,
    required this.database,
    required this.name,
    required this.days,
    required this.clasS,
    required this.classDateTime,
  });
}
