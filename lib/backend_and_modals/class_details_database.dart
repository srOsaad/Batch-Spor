import 'package:hive/hive.dart';
import '../backend_and_modals/batch_class.dart';
import 'key_data2.dart';

class ClassDetailsDatabase {
  Box<ClassDetails>? classDetailsBox;

  Future<void> initDatabase(String boxName) async {
    classDetailsBox = await Hive.openBox<ClassDetails>(boxName);
  }

  List<key_data> refreshDatabase() {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    return classDetailsBox!.toMap().entries.map((ele) {
      return key_data(key: ele.key, classDetails: ele.value);
    }).toList();
  }

  Future<void> addDetails(ClassDetails classDetails) async {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    await classDetailsBox!.add(classDetails);
  }

  Future<void> updateDetails(key_data classDetailsKD) async {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    await classDetailsBox!.put(classDetailsKD.key, classDetailsKD.classDetails);
  }

  Future<ClassDetails?> getDetailsByKey(dynamic key) async {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    return classDetailsBox!.get(key);
  }

  Future<void> removeDetails(dynamic key) async {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    await classDetailsBox!.delete(key);
  }

  Future<void> deleteDatabase() async {
    if (classDetailsBox == null) {
      throw Exception('ClassDetails box is not initialized');
    }
    await classDetailsBox!.clear();
    await classDetailsBox!.close();
    Hive.deleteBoxFromDisk(classDetailsBox!.name);
    classDetailsBox = null;
  }

  void dispose() {
    classDetailsBox?.close();
    classDetailsBox = null;
  }
}
