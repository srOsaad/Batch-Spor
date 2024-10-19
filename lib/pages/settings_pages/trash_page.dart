import 'package:flutter/material.dart';
import '/backend_and_modals/batch_class.dart';
import '/backend_and_modals/key_data.dart';
import '../../backend_and_modals/batch_details_database.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  BatchDetailsDatabase trashDatabase = BatchDetailsDatabase();
  BatchDetailsDatabase batchDetailsDatabase = BatchDetailsDatabase();
  List<key_data> trash = [];
  List<bool> trashCheckbox = [];
  bool isLoading = true, showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    initDatabase();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showLoadingIndicator = true;
        });
      }
    });
  }

  @override
  void dispose() {
    batchDetailsDatabase.dispose();
    trashDatabase.dispose();
    super.dispose();
  }

  void initDatabase() async {
    await trashDatabase.initDatabase('trash');
    await batchDetailsDatabase.initDatabase('batch');
    refreshDatabase();
    setState(() {
      isLoading = false;
    });
  }

  void refreshDatabase() {
    try {
      trash = trashDatabase.refreshDatabase();
      trashCheckbox.clear();
      for (int i = 0; i < trash.length; i++) {
        trashCheckbox.add(false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error retriving deleted batch'),
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void removeAndRestore(dynamic key) {
    try {
      Batch? adBatch;
      for (var x in trash) {
        if (x.key == key) {
          adBatch = x.batch;
          break;
        }
      }
      if (adBatch != null) {
        batchDetailsDatabase.addNewBatch(adBatch);
      }
      trashDatabase.removeBatch(key);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error removing batch'),
        ),
      );
    }
  }

  void deletePermanently() {
    for (int i = 0; i < trash.length; i++) {
      if (trashCheckbox[i] == false) continue;
      trashDatabase.deleteClassDetailsDatabase(trash[i].batch.database);
      trashDatabase.removeBatch(trash[i].key);
    }
    refreshDatabase();
  }

  void restore() {
    for (int i = 0; i < trash.length; i++) {
      if (trashCheckbox[i] == false) continue;
      removeAndRestore(trash[i].key);
    }
    refreshDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && showLoadingIndicator) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                deletePermanently();
              },
              child: const Icon(Icons.delete_forever)),
          TextButton(
              onPressed: () {
                restore();
              },
              child: const Icon(Icons.restore))
        ],
      ),
      body: trash.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(image: AssetImage('assets/bin.png')),
                  SizedBox(height: 0),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                  itemCount: trash.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(trash[index].batch.name),
                        Checkbox(
                            value: trashCheckbox[index],
                            onChanged: (p0) {
                              setState(() {
                                trashCheckbox[index] =
                                    p0 ?? trashCheckbox[index];
                              });
                            })
                      ],
                    );
                  }),
            ),
    );
  }
}
