import 'package:flutter/material.dart';
import '../../../backend_and_modals/batch_class.dart';

class AddModify extends StatefulWidget {
  const AddModify(
      {super.key, required this.onDone, required this.classDetails});
  final ClassDetails? classDetails;
  final Function(ClassDetails classDetails) onDone;
  @override
  State<AddModify> createState() => _AddModifyState();
}

class _AddModifyState extends State<AddModify> {
  final TextEditingController cw = TextEditingController();
  final TextEditingController hw = TextEditingController();
  final TextEditingController offlineExam = TextEditingController();
  final TextEditingController onlineExam = TextEditingController();
  TimeOfDay createdAtTime = TimeOfDay.now();
  DateTime createdAtDate = DateTime.now();

  void checkClassDetails() {
    if (widget.classDetails != null) {
      cw.text = widget.classDetails!.cw;
      hw.text = widget.classDetails!.hw;
      offlineExam.text = widget.classDetails!.offlineExam;
      onlineExam.text = widget.classDetails!.onlineExam;
      print('${cw.text} ${widget.classDetails!.cw}');
      createdAtTime = TimeOfDay(
          hour: widget.classDetails!.createdAt.hour,
          minute: widget.classDetails!.createdAt.minute);
      createdAtDate = widget.classDetails!.createdAt;
    }
  }

  void refineInputs() {
    cw.text = cw.text.trim();
    hw.text = hw.text.trim();
    offlineExam.text = offlineExam.text.trim();
    onlineExam.text = onlineExam.text.trim();
  }

  bool isModification() {
    refineInputs();
    createdAtDate = DateTime(createdAtDate.year, createdAtDate.month,
        createdAtDate.day, createdAtTime.hour, createdAtTime.minute);
    return cw.text != widget.classDetails!.cw ||
        hw.text != widget.classDetails!.hw ||
        offlineExam.text != widget.classDetails!.offlineExam ||
        onlineExam.text != widget.classDetails!.onlineExam ||
        createdAtDate.year != widget.classDetails!.createdAt.year ||
        createdAtDate.month != widget.classDetails!.createdAt.month ||
        createdAtDate.day != widget.classDetails!.createdAt.day ||
        createdAtDate.hour != widget.classDetails!.createdAt.hour ||
        createdAtDate.minute != widget.classDetails!.createdAt.minute;
  }

  void flush() {
    cw.text = '';
    hw.text = '';
    offlineExam.text = '';
    onlineExam.text = '';
    createdAtTime = TimeOfDay.now();
    createdAtDate = DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    checkClassDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              const Text('Class Details',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: cw,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'CW',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: hw,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'HW',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: offlineExam,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Offline Exam',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: onlineExam,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Online Exam',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: createdAtTime,
                        initialEntryMode: TimePickerEntryMode.input,
                        orientation: Orientation.portrait,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
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
                        createdAtTime = time ?? TimeOfDay.now();
                      });
                    },
                    child:
                        Text('${createdAtTime.hour} : ${createdAtTime.minute}'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: createdAtDate,
                        initialEntryMode: DatePickerEntryMode.calendar,
                        firstDate: DateTime(2024, 10, 18),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
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
                        createdAtDate = date ?? DateTime.now();
                      });
                    },
                    child: Text(
                        '${createdAtDate.year}/${createdAtDate.month}/${createdAtDate.day}'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () async {
                  if (widget.classDetails == null || isModification()) {
                    widget.onDone(
                      ClassDetails(
                        cw: cw.text,
                        hw: hw.text,
                        offlineExam: offlineExam.text,
                        onlineExam: onlineExam.text,
                        createdAt: createdAtDate,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text(widget.classDetails == null ? 'Add' : 'Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
