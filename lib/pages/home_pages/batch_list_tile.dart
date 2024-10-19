import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'batch_data/note_page.dart';

class BatchListTile extends StatelessWidget {
  final dynamic bKey;
  final String name;
  final String database;
  final Color color;
  final Color textColor;
  final Function(dynamic) onEdit;
  final Function(dynamic) onRemove;

  const BatchListTile({
    required this.bKey,
    required this.name,
    required this.color,
    required this.textColor,
    required this.database,
    required this.onEdit,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(
            name: name,
            database: database,
            color: color,
            textColor: textColor,
          ),
        ),
      ),
      child: Dismissible(
        key: UniqueKey(),
        background: _buildEditBackground(),
        secondaryBackground: _buildRemoveBackground(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return true;
          } else {
            onEdit(bKey);
            return false;
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onRemove(bKey);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(
                      name,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.edit, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            'Edit',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveBackground() {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Remove',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(width: 10),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
    );
  }
}
