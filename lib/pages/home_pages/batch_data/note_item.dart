import 'package:flutter/material.dart';
import '../../../backend_and_modals/key_data2.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onRemove,
    required this.onUndo,
  });
  final key_data note;
  final Function(dynamic) onEdit;
  final Function(key_data) onRemove;
  final Function(key_data) onUndo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "${note.classDetails.createdAt.day}-${note.classDetails.createdAt.month}-${note.classDetails.createdAt.year}       ${note.classDetails.createdAt.hour}:${note.classDetails.createdAt.minute}"),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        onRemove(note);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Removed!'),
                            behavior: SnackBarBehavior.fixed,
                            action: SnackBarAction(
                              label: 'UNDO',
                              textColor: Colors.blue,
                              onPressed: () {
                                onUndo(note);
                              },
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      onEdit(note.key);
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: 'CW',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(note.classDetails.cw),
              ],
            ),
          ),
          const Divider(),
          Tooltip(
            message: 'HW',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(note.classDetails.hw),
              ],
            ),
          ),
          const Divider(),
          Tooltip(
            message: 'Offline Exam',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(note.classDetails.offlineExam),
              ],
            ),
          ),
          const Divider(),
          Tooltip(
            message: 'Online Exam',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(note.classDetails.onlineExam),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
