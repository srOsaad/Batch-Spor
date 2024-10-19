import 'package:flutter/material.dart';
import '../backend_and_modals/key_data.dart';
import '../backend_and_modals/settings_data.dart';
import '../backend_and_modals/sort_algos.dart';
import '/pages/home_pages/batch_list_tile.dart';
import '../pages/home_pages/add_modify.dart';
import '../backend_and_modals/batch_details_database.dart';
import '../backend_and_modals/batch_class.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.settingsData,
      required this.onClassLeftChanged});
  SettingsData settingsData;
  final Function(int) onClassLeftChanged;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int change = 0;
  bool isLoading = true, showLoadingIndicator = false;
  BatchDetailsDatabase batchDetailsDatabase = BatchDetailsDatabase();
  BatchDetailsDatabase trashDatabase = BatchDetailsDatabase();
  List<key_data> priority = [];
  List<key_data> batchAll = [];

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
    trashDatabase.dispose();
    batchDetailsDatabase.dispose();
    super.dispose();
  }

  void initDatabase() async {
    await batchDetailsDatabase.initDatabase('batch');
    await trashDatabase.initDatabase('trash');
    refreshDatabase();
    if (mounted) {
      setState(() {});
    }
    isLoading = false;
  }

  void refreshDatabase() {
    try {
      batchAll = batchDetailsDatabase.refreshDatabase();
      if (widget.settingsData.sortingOption == 4) {
        batchAll = batchAll.reversed.toList();
      }
      sortData(Sortalgos(bn: batchAll));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error refreshing database'),
        ),
      );
    }

    if (!widget.settingsData.ascendingMode) {
      batchAll = batchAll.reversed.toList();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void sortData(Sortalgos sortalgos) {
    if (widget.settingsData.priorityMode) {
      priority = sortalgos.priorityMode();
      widget.onClassLeftChanged(priority.length);
    }
    if (widget.settingsData.sortingOption != 4) {
      sortalgos.sortByTime();
      switch (widget.settingsData.sortingOption) {
        case 0:
          sortalgos.sortByName();
          break;
        case 2:
          sortalgos.sortByClass();
          break;
        case 3:
          sortalgos.sortByWeek();
          break;
      }
    }
  }

  Future<void> addNewBatch(Batch batch) async {
    try {
      bool result = await batchDetailsDatabase.addNewBatch(batch);
      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already exists!'),
          ),
        );
      }
      refreshDatabase();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> updateBatch(key_data batchKD) async {
    try {
      batchDetailsDatabase.updateBatch(batchKD);
      refreshDatabase();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating batch'),
        ),
      );
    }
  }

  void removeBatch(dynamic key) async {
    try {
      Batch? rmBatch = await batchDetailsDatabase.getBatchByKey(key);
      if (rmBatch != null) {
        batchDetailsDatabase.removeBatch(key);
        trashDatabase.addNewBatch(rmBatch);
      }
      refreshDatabase();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error removing batch'),
        ),
      );
    }
  }

  void addModifyBatch(dynamic key) async {
    Batch? batch = await batchDetailsDatabase.getBatchByKey(key);
    await showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AddModify(
          batch: batch,
          onDone: (batch) async {
            if (key == null) {
              await addNewBatch(batch);
            } else {
              await updateBatch(key_data(key: key, batch: batch));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && showLoadingIndicator) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (priority.isEmpty && batchAll.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(image: AssetImage('assets/home.png')),
            SizedBox(height: 0),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: priority.length,
              itemBuilder: (context, index) {
                return BatchListTile(
                  bKey: priority[index].key,
                  name: priority[index].batch.name,
                  color: widget.settingsData.colorAscent,
                  textColor: widget.settingsData.colorAscentText,
                  database: priority[index].batch.database,
                  onEdit: (p0) => addModifyBatch(p0),
                  onRemove: (p0) {
                    removeBatch(p0);
                  },
                );
              },
            ),
          ),
          priority.isEmpty ? const SizedBox() : const Divider(),
          priority.isEmpty
              ? const SizedBox()
              : Text(
                  '${priority.length} ${priority.length == 1 ? 'class' : 'classes'}'),
          priority.isEmpty ? const SizedBox() : const Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: batchAll.length,
              itemBuilder: (context, index) {
                return BatchListTile(
                  bKey: batchAll[index].key,
                  name: batchAll[index].batch.name,
                  color: widget.settingsData.colorAscent,
                  textColor: widget.settingsData.colorAscentText,
                  database: batchAll[index].batch.database,
                  onEdit: (p0) => addModifyBatch(p0),
                  onRemove: (p0) {
                    removeBatch(p0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
