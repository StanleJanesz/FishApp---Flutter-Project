import 'package:flutter/material.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:fish_app/Widgets/number_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:fish_app/Widgets/date_time_picker.dart';
import 'package:fish_app/Widgets/search_choice_list.dart';
import 'package:fish_app/widgets/fish_type_picker.dart';
import 'package:fish_app/widgets/fishing_spot_picker.dart';
import 'package:select_field/select_field.dart';
class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final _formKey = GlobalKey<FormState>(); // Global key for form state
  SelectFieldMenuController<int> typeController = SelectFieldMenuController<int>();
  SelectFieldMenuController<int> spotController = SelectFieldMenuController<int>();
  final TextEditingController _intController = TextEditingController();
  DateTime? pickedDate;
  List<String> items = FishType.types;
  String? selectedItem;
  Fish fish = Fish(
    id : 0,
      size: 0,
      date: DateTime.now(),
      catchedBy: "user",
      type: 0,
      spotId: 0,
      baitId: 0,
      weatherId: 0,
  );

  final TextEditingController _dateController = TextEditingController();



  // This method validates and shows the input values
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, show a dialog with the input values
      final size = _intController.text;

      // Optionally convert the int input to a number if needed
      final intSize = int.tryParse(size);
      final type = typeController.selectedOption?.value ?? 0;
      final spot = spotController.selectedOption?.value ?? 0;
      fish.size = intSize ?? 0;
      fish.date = pickedDate ?? DateTime.now();
      fish.catchedBy = "user";
      fish.type = type;
      fish.spotId = spot;
      fish.baitId = 0; 
      print(spot);
      DatabaseServiceFish databaseServiceFish = DatabaseServiceFish();

       

      Navigator.pop(
          context, fish); // Go back to the previous screen after submission
      final databseServis = DatabaseServiceFish();
      await databseServis.addFish(fish);
      List<Fish> fff= await databaseServiceFish.getAllBySpotId(spot);
      print(fff.length);
      final test = await databseServis.getAll();
      print(test.length);
    }
  }

  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    if (pickedDate == null) {
      _dateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
    }
    return Scaffold(
      appBar: AppBar(title: Text('New Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                  value: checkboxValue,
                  onChanged: (value) {
                    setState(() {
                      checkboxValue = value!;
                    });
                  }),
             
              FishSizeWidget(isSelected: checkboxValue,textController: _intController),
              SizedBox(height: 20),
              Text('date'),
              DateTimePicker(dateController: _dateController),
              Text('type'),
              FishTypePicker(menuController: typeController),   
              FishingSpotPicker(menuController: spotController),
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



































class FishSizeWidget extends StatefulWidget {
  bool isSelected = false;
  TextEditingController textController = TextEditingController(); 
  FishSizeWidget({super.key, required this.isSelected,required this.textController});
  @override
  _FishSizeWidgetState createState() => _FishSizeWidgetState();
}

class _FishSizeWidgetState extends State<FishSizeWidget> {
  final int _currentValue = 3;
  
  @override
  Widget build(BuildContext context) {
    if(!widget.isSelected)
    {
    return Column(   
      children: <Widget>[
        IntegerExample(   intController: widget.textController),    
        Text('Current value: $_currentValue'),
      ],
    );
    }
    else
    {
      return  TextFormField(
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
                  return null;
                },
              );
    }
  }
}