import 'package:flutter/material.dart';
import '../../backend_and_modals/batch_class.dart';
import 'package:day_picker/day_picker.dart';

class AddModify extends StatefulWidget {
  AddModify({super.key, required this.batch, required this.onDone});
  Batch? batch;
  final Function(Batch batch) onDone;

  @override
  State<AddModify> createState() => _AddModifyState();
}

class _AddModifyState extends State<AddModify> {
  bool errorFound = false;
  final _batchName = TextEditingController();
  List<int> _selectedDays = [];
  int? _selectedClass;
  TimeOfDay? _selectedTime;
  final List<int> _availableClasses = [4, 5, 6, 7, 8, 9, 10, 11, 12];
  final List<DayInWeek> _days = [
    DayInWeek("SA", dayKey: "1"),
    DayInWeek("S", dayKey: "2"),
    DayInWeek("M", dayKey: "3"),
    DayInWeek("T", dayKey: "4"),
    DayInWeek("W", dayKey: "5"),
    DayInWeek("TH", dayKey: "6"),
    DayInWeek("F", dayKey: "7"),
  ];

  void checkBatchDetails() {
    if (widget.batch != null) {
      _batchName.text = widget.batch!.name;
      _selectedClass = widget.batch!.clasS;
      _selectedDays = widget.batch!.days;
      _selectedTime = TimeOfDay(
          hour: widget.batch!.classDateTime.hour,
          minute: widget.batch!.classDateTime.minute);
      for (var x in _selectedDays) {
        _days[x - 1].isSelected = true;
      }
    }
  }

  bool checkAllInput() {
    _batchName.text = _batchName.text.trim();
    errorFound = false;
    if (_batchName.text.toString() == "" ||
        _selectedClass == null ||
        _selectedDays.isEmpty ||
        _selectedTime == null) {
      errorFound = true;
      setState(() {});
    }
    return !errorFound;
  }

  void flush() {
    errorFound = false;
    _batchName.clear();
    _selectedClass = null;
    _selectedTime = null;
    _selectedDays = [];
    for (int i = 0; i < 7; i++) {
      _days[i].isSelected = false;
    }
  }

  String getNewDatabaseName() {
    DateTime now = DateTime.now();
    String year = now.year.toString().padLeft(4, '0');
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');
    String millisecond = now.millisecond.toString().padLeft(3, '0');
    return '$year$month$day$hour$minute$second$millisecond';
  }

  String convertCapitalsToLower(String input) {
    return input.split('').map((char) {
      return char.toUpperCase() == char ? char.toLowerCase() : char;
    }).join('');
  }

  @override
  void initState() {
    super.initState();
    checkBatchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  widget.batch == null ? 'New Batch' : widget.batch!.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _batchName,
                  decoration: const InputDecoration(
                    labelText: 'Batch name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  isDense: true,
                  decoration: const InputDecoration(
                    labelText: 'Select class',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedClass,
                  items: _availableClasses.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Class $value'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedClass = value;
                  },
                ),
                const SizedBox(height: 20),
                SelectWeekDays(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  days: _days,
                  border: false,
                  unselectedDaysBorderColor:
                      Theme.of(context).colorScheme.outline,
                  selectedDaysFillColor: Theme.of(context).colorScheme.primary,
                  unSelectedDayTextColor: Theme.of(context).colorScheme.primary,
                  selectedDayTextColor: Theme.of(context).colorScheme.onPrimary,
                  boxDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  onSelect: (values) {
                    _selectedDays = values.map(int.parse).toList();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                      orientation: Orientation.portrait,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat: true,
                              ),
                              child: child!,
                            ),
                          ),
                        );
                      },
                    );
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Text(_selectedTime != null
                      ? "${_selectedTime!.hour} : ${_selectedTime!.minute}"
                      : "Select Time"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: errorFound
                      ? const Text(
                          'Please complete the remaining!',
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    flush();
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (checkAllInput()) {
                      _selectedDays.sort((a, b) => b.compareTo(a));
                      await widget.onDone(Batch(
                          nameLowerCase:
                              convertCapitalsToLower(_batchName.text),
                          database: getNewDatabaseName(),
                          name: _batchName.text,
                          days: _selectedDays,
                          clasS: _selectedClass!,
                          classDateTime: DateTime(0, 0, 0, _selectedTime!.hour,
                              _selectedTime!.minute)));
                      Navigator.pop(context);
                      flush();
                    }
                  },
                  child: Text(widget.batch == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
