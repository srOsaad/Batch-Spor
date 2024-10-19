import 'package:flutter/material.dart';
import '../../backend_and_modals/settings_data.dart';

class SortOptions extends StatefulWidget {
  const SortOptions(
      {super.key, required this.settingsData, required this.onSettingsChanged});
  final SettingsData settingsData;
  final Function(SettingsData) onSettingsChanged;

  @override
  State<SortOptions> createState() => _SortOptionsState();
}

class _SortOptionsState extends State<SortOptions> {
  late bool ascending;
  late String sortOption;
  int sortOptionInt(String sortingOption) {
    return sortingOption == 'Time'
        ? 1
        : sortingOption == 'Class'
            ? 2
            : sortingOption == 'Week'
                ? 3
                : sortingOption == 'Date Added'
                    ? 4
                    : 0;
  }

  String sortOptionString(int u) {
    return u == 1
        ? 'Time'
        : u == 2
            ? 'Class'
            : u == 3
                ? 'Week'
                : u == 4
                    ? 'Date Added'
                    : 'Name';
  }

  final List<String> _sortOptions = [
    'Name',
    'Time',
    'Class',
    'Week',
    'Date Added'
  ];

  @override
  void initState() {
    ascending = widget.settingsData.ascendingMode;
    sortOption = sortOptionString(widget.settingsData.sortingOption);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sort by",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ascending'),
                Switch(
                  value: ascending,
                  onChanged: (value) {
                    setState(() {
                      ascending = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: sortOptionString(widget.settingsData.sortingOption),
              decoration: const InputDecoration(
                labelText: 'Sorting Option',
                border: OutlineInputBorder(),
              ),
              items: _sortOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  sortOption = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.settingsData.ascendingMode = ascending;
                    widget.settingsData.sortingOption =
                        sortOptionInt(sortOption);
                    widget.onSettingsChanged(widget.settingsData);
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
