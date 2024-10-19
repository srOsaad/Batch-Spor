import 'package:hive/hive.dart';
import '../backend_and_modals/batch_class.dart';
import '../backend_and_modals/key_data.dart';

class BatchDetailsDatabase {
  Box<Batch>? batchBox;

  Future<void> initDatabase(String dbName) async {
    batchBox = await Hive.openBox<Batch>(dbName);
  }

  void dispose() {
    batchBox?.close();
  }

  List<key_data> refreshDatabase() {
    if (batchBox == null) {
      throw Exception('Batch box is not initialized');
    }
    List<key_data> batchAllDetails = batchBox!.toMap().entries.map((ele) {
      return key_data(key: ele.key, batch: ele.value);
    }).toList();
    return batchAllDetails;
  }

  Future<bool> addNewBatch(Batch batch) async {
    if (batchBox == null) {
      throw Exception('Batch box is not initialized');
    }
    if (batchBox!.values
        .any((batcH) => batcH.nameLowerCase == batch.nameLowerCase)) {
      return false;
    }
    await batchBox!.add(batch);
    return true;
  }

  Future<void> updateBatch(key_data batchKD) async {
    if (batchBox == null) {
      throw Exception('Batch box is not initialized');
    }
    await batchBox!.put(batchKD.key, batchKD.batch);
  }

  Future<void> removeBatch(dynamic key) async {
    if (batchBox == null) {
      throw Exception('Batch box is not initialized');
    }
    await batchBox!.delete(key);
  }

  Future<Batch?> getBatchByKey(dynamic key) async {
    try {
      if (batchBox == null) {
        throw Exception('Batch box is not initialized');
      }
      if (batchBox!.containsKey(key)) {
        return batchBox!.get(key);
      }
    } catch (e) {
      throw Exception('Error retrieving batch: $e');
    }
    return null;
  }

  Future<void> deleteClassDetailsDatabase(String boxName) async {
    if (boxName == "") {
      return;
    }
    final box = await Hive.openBox<Batch>(boxName);
    await box.deleteFromDisk();
  }
}
