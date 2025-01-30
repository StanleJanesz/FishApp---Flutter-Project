
import 'package:flutter/material.dart';
import 'package:fish_app/Widgets/number_picker.dart';


class FishSizeWidget extends StatefulWidget {
  final bool? isSelected;
  final TextEditingController textController;
  const FishSizeWidget({super.key, this.isSelected, required this.textController});
  @override
  FishSizeWidgetState createState() => FishSizeWidgetState();
}

class FishSizeWidgetState extends State<FishSizeWidget> {
  late bool? isSelected;
  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (!(widget.isSelected ?? false)) {
      return Column(
        children: <Widget>[
          IntegerExample(intController: widget.textController),
        ],
      );
    } else {
      return TextFormField(
        controller: widget.textController,
        keyboardType: TextInputType.number, // Only numbers allowed
        decoration: InputDecoration(
          labelText: 'Enter an Fish Size',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Fish Size';
          }
          final intValue = int.tryParse(value);
          if (intValue == null) {
            return 'Please enter a valid integer';
          }
          if (intValue <= 0) {
            return 'Please enter a positive integer';
          }
          if (intValue > 1000) {
            return 'Please enter a number less than 1000';
          }
          return null;
        },
      );
    }
  }
}
