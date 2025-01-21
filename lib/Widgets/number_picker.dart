import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class IntegerExample extends StatefulWidget {
  TextEditingController  intController = TextEditingController();
  IntegerExample({Key? key, required this.intController}) : super(key: key);
  @override
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  int _currentValue = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: widget.intController.text.isEmpty ? 0 : int.parse(widget.intController.text),
           axis : Axis.horizontal,
          minValue: 0,
          maxValue: 100,
          onChanged: (value) => setState(() { _currentValue =  value;
          widget.intController.text = value.toString();
          widget.intController.value = TextEditingValue(text: value.toString());
  }) ,
        ),
      ],
    );
  }
}