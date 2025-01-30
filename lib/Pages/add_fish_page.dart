import 'package:fish_app/Classes/weather.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:fish_app/Widgets/date_time_picker.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/fishing_spot_picker.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/fish_type_picker.dart';
import 'package:select_field/select_field.dart';
import 'package:weather/weather.dart';
import 'package:fish_app/Services/weather_service.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/bait_picker.dart';
import 'package:fish_app/Widgets/fish_size_widget.dart';
class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
  final _formKey = GlobalKey<FormState>(); // Global key for form state
  SelectFieldMenuController<int> typeController =
      SelectFieldMenuController<int>();
  SelectFieldMenuController<int> spotController =
      SelectFieldMenuController<int>();
  SelectFieldMenuController<int> baitController =
      SelectFieldMenuController<int>();
  final TextEditingController _intController = TextEditingController();
  DateTime? pickedDate;
  List<String> items = FishType.types;
  String? selectedItem;
  Fish fish = Fish(
    id: 0,
    size: 0,
    date: DateTime.now(),
    catchedBy: "user",
    type: 0,
    spotId: 0,
    baitId: 0,
    weatherId: 0,
  );

  final TextEditingController _dateController = TextEditingController();

  void _addfish() async {
    final size = _intController.text;
    final intSize = int.tryParse(size);
    final type = typeController.selectedOption?.value ?? 0;
    final spot = spotController.selectedOption?.value ?? 0;
    final bait = baitController.selectedOption?.value ?? 0;
    fish.size = intSize ?? 0;
    fish.date = pickedDate ?? DateTime.now();
    fish.catchedBy = "user";
    fish.type = type;
    fish.spotId = spot;
    fish.baitId = bait;
    int weatherId = 0;
    try {
      WeatherService weatherService = WeatherService();
      Weather? weather = await weatherService.getWeatherOnline();
      if (weather == null) {
        throw Exception('Failed to get weather data');
      }
      WeatherLocal wetherToBeSaved = WeatherLocal.adaptFromWeather(weather);
      final databaseServiceWeather = DatabseServiceWeather();
      weatherId = await databaseServiceWeather.addWeather(wetherToBeSaved);
      fish.weatherId = weatherId;
    } 
    catch (e) 
    {
      fish.weatherId = 0;
    }
    fish.weatherId = weatherId;

    final databaseServiceFish = DatabaseServiceFish();
    databaseServiceFish.addFish(fish);
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _addfish();
      Navigator.pop(context);
    }
  }

  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    if (pickedDate == null) {
      _dateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
    }
    return Scaffold(
      appBar: AppBar(title: Text('New Fish Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/boat.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),

              FishSizeWidget(
                  isSelected: checkboxValue, textController: _intController),
              Row(
                children: [
                  Text('use number picker'),
                  Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        setState(() {
                          checkboxValue = value!;
                        });
                      }),
                ],
              ),
              SizedBox(height: 20),
              Text('date'),
              DateTimePicker(dateController: _dateController),

              FishTypePicker(menuController: typeController),
              Text('Select a fish type'),

              BaitPicker(menuController: baitController),
              Text('Select a bait'),

              FishingSpotPicker(menuController: spotController),
              Text('Select a fishing spot'),
              SizedBox(height: 20),

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
