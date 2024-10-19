import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatChange12HourT(TimeOfDay dt) {
  return DateFormat.jm().format(DateTime(0, 0, 0, dt.hour, dt.minute));
}

String formatChange12HourD(DateTime dt) {
  return DateFormat.jm().format(DateTime(0, 0, 0, dt.hour, dt.minute));
}
