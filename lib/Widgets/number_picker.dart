import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class IntegerExample extends StatefulWidget {
  final TextEditingController intController;
  IntegerExample({super.key, required this.intController}) {
    int value = intController.text.isEmpty ? 1 : int.parse(intController.text);
    value = value < 1 ? 1 : value;
    value = value > 1000 ? 1000 : value;
    intController.text = value.toString();
  }
  @override
  IntegerExampleState createState() => IntegerExampleState();
}

class IntegerExampleState extends State<IntegerExample> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: widget.intController.text.isEmpty
              ? 0
              : int.parse(widget.intController.text),
          axis: Axis.horizontal,
          minValue: 1,
          maxValue: 1000,
          onChanged: (value) => setState(() {
            widget.intController.text = value.toString();
            widget.intController.value =
                TextEditingValue(text: value.toString());
          }),
        ),
      ],
    );
  }
}
