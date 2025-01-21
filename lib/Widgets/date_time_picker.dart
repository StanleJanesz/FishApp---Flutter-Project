import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget
{


  final TextEditingController dateController;


  DateTimePicker({required this.dateController});
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}



class _DateTimePickerState extends State<DateTimePicker> {
void selectDate(BuildContext context) async {
    // Get the current date
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);

    // Show the date picker
     final DateTime? result = await showAdaptiveDateTimePicker(
   context: context,
   initialPickerDateTime: initialDate,
    firstDate: firstDate,
    lastDate: initialDate,
   mode: DateTimeFieldPickerMode.dateAndTime,
 );
    // If the user picked a date, update the controller with the formatted date
    if (result != null && result != initialDate) {
      setState(() {
        widget.dateController.text =
            "${result.toLocal()}".split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: widget.dateController,
            decoration: InputDecoration(
              labelText: 'Date',
            ),
            readOnly: true,
            onTap: () => selectDate(context),
          ),
        ),
      ],
    );
  }
}