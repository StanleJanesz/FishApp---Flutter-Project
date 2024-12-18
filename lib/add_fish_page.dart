import 'package:flutter/material.dart';
import 'package:fish_app/Classes/fish.dart';
class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final _formKey = GlobalKey<FormState>(); // Global key for form state
  final TextEditingController _intController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  DateTime? pickedDate ;
  List<String> items = FishType().types;
  String? selectedItem;
  Fish fish = Fish();

   final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    // Get the current date
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);
    
    // Show the date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // If the user picked a date, update the controller with the formatted date
    if (pickedDate != null && pickedDate != initialDate) {
      this.pickedDate = pickedDate;
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format: YYYY-MM-DD
      });
    
    }
    }

  // This method validates and shows the input values
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, show a dialog with the input values
      final intInput = _intController.text;
      final textInput = _textController.text;

      // Optionally convert the int input to a number if needed
      final intValue = int.tryParse(intInput);
      fish.size = intValue ?? 0;
      fish.date = pickedDate ?? DateTime.now();
      fish.catchedBy = textInput;
      fish.type.type = selectedItem ?? "Unknown";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Form Submitted'),
          content: Text(
            'Integer input: $intValue\nText input: $textInput',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context,fish); // Go back to the previous screen after submission
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
    return Scaffold(
      appBar: AppBar(title: Text('New Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Integer input field
              TextFormField(
                controller: _intController,
                keyboardType: TextInputType.datetime, // Only numbers allowed
                decoration: InputDecoration(
                  labelText: 'Enter an Integer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an integer';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Text input field
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
              controller: _dateController,
              readOnly: true, // Disable manual editing
              
              decoration: InputDecoration(
                labelText: 'Select a Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context), // Trigger date picker when tapped
            ),
              DropdownButton<String>(
          value: selectedItem,
          hint: Text('Select an item'),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
            });
          },
        ),
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
