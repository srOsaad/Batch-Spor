import 'package:flutter/material.dart';
import '/pages/home_pages/batch_data/note_item.dart';
import '../../../backend_and_modals/batch_class.dart';
import '../../../backend_and_modals/key_data2.dart';
import '../../../backend_and_modals/class_details_database.dart';
import 'add_modify.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class NotePage extends StatefulWidget {
  NotePage(
      {super.key,
      required this.name,
      required this.database,
      required this.color,
      required this.textColor});
  final String name;
  Color color;
  Color textColor;
  final String database;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isLoading = true, showLoadingIndicator = false;
  ClassDetailsDatabase classDetailsDatabase = ClassDetailsDatabase();
  List<key_data> notes = [];
  List<key_data> trash = [];

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
    classDetailsDatabase.dispose();
    super.dispose();
  }

  void initDatabase() async {
    await classDetailsDatabase.initDatabase(widget.database);
    refreshDatabase();
    setState(() {
      isLoading = false;
    });
  }

  void refreshDatabase() {
    var temp = classDetailsDatabase.refreshDatabase().reversed.toList();
    setState(() {
      notes = temp;
    });
  }

  Future<void> addNote(ClassDetails classDetails) async {
    await classDetailsDatabase.addDetails(classDetails);
    refreshDatabase();
  }

  Future<void> removeNote(dynamic key) async {
    await classDetailsDatabase.removeDetails(key);
    refreshDatabase();
  }

  Future<void> updateNote(key_data classDetailsKD) async {
    await classDetailsDatabase.updateDetails(classDetailsKD);
    refreshDatabase();
  }

  void addModifyClassDetails(dynamic key) async {
    ClassDetails? classDetails;
    if (key != null) {
      try {
        classDetails = await classDetailsDatabase.getDetailsByKey(key);
      } catch (e) {
        print("$e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
          ),
        );
      }
    }

    await showTopModalSheet(
      context,
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AddModify(
          classDetails: classDetails,
          onDone: (classDetailS) async {
            if (key == null) {
              await addNote(classDetailS);
            } else {
              await updateNote(key_data(key: key, classDetails: classDetailS));
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    );
    refreshDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: isLoading && showLoadingIndicator
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(image: AssetImage('assets/batch.png')),
                      SizedBox(height: 0),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteItem(
                          note: key_data(
                              key: notes[index].key,
                              classDetails: notes[index].classDetails),
                          onEdit: (p0) {
                            addModifyClassDetails(p0);
                          },
                          onRemove: (p0) {
                            classDetailsDatabase.removeDetails(p0.key);
                            refreshDatabase();
                          },
                          onUndo: (p0) {
                            classDetailsDatabase.updateDetails(p0);
                            refreshDatabase();
                          },
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.color,
        onPressed: () => addModifyClassDetails(null),
        child: Icon(
          Icons.add,
          color: widget.textColor,
        ),
      ),
    );
  }
}
