import 'package:raccoltalatte/theme.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {super.key,
      required this.date,
      required this.onChanged,
      required this.admin});
  final DateTime date;
  final ValueSetter<DateTime> onChanged;
  final bool admin;

  @override
  // ignore: no_logic_in_create_state
  DateTimePickerState createState() => DateTimePickerState(date);
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime date;
  DateTimePickerState(this.date);
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
        currentDate: date);

    if (picked != null) {
      setState(() {
        date = date.copyWith(
            year: picked.year, month: picked.month, day: picked.day);
        widget.onChanged(date);
      });
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: date.hour, minute: date.minute));

    if (picked != null) {
      setState(() {
        date = date.copyWith(hour: picked.hour, minute: picked.minute);
        widget.onChanged(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.admin) {
      return Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(MyTheme.padding),
                child: Text('Data'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: Text('${date.day}/${date.month}/${date.year}'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: IconButton(
                    onPressed: () => selectDate(context),
                    icon: const Icon(Icons.date_range)),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(MyTheme.padding),
                child: Text('Ora'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: Text('${date.hour}:${date.minute}'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: IconButton(
                    onPressed: () => selectTime(context),
                    icon: const Icon(Icons.access_time)),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(MyTheme.padding),
                child: Text('Data'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: Text('${date.day}/${date.month}/${date.year}'),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(MyTheme.padding),
                child: Text('Ora'),
              ),
              Padding(
                padding: const EdgeInsets.all(MyTheme.padding),
                child: Text('${date.hour}:${date.minute}'),
              ),
            ],
          ),
        ],
      );
    }
  }
}
