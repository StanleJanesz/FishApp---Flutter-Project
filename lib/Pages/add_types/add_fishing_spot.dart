import 'package:flutter/material.dart';
import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:fish_app/Services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class FishingSpotFormPage extends StatefulWidget {
  const FishingSpotFormPage({super.key});

  @override
  State<FishingSpotFormPage> createState() => _FishingSpotFormPageState();
}

class _FishingSpotFormPageState extends State<FishingSpotFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  void getLocation() async {
    Position location;
    try {
      location = await determinePosition();
    } catch (e) {
      return;
    }
    _longitudeController.text = location.longitude.toString();
    _latitudeController.text = location.latitude.toString();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final spot = FishingSpot(
        id: 0,
        name: _nameController.text,
        longitude: double.parse(_longitudeController.text),
        latitude: double.parse(_latitudeController.text),
      );

      DatabaseServiceFishingSpot databaseServiceFishingSpot =
          DatabaseServiceFishingSpot();
      databaseServiceFishingSpot.addFishingSpot(spot);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fishing spot saved successfully!')),
      );
      Navigator.of(context).pop();
      // Clear the form
      _nameController.clear();
      _longitudeController.clear();
      _latitudeController.clear();
    }
  }

  String? _validateCoordinate(String? value, String type) {
    if (value == null || value.isEmpty) {
      return 'Please enter $type';
    }
    final coordinate = double.tryParse(value);
    if (coordinate == null) {
      return 'Please enter a valid number';
    }
    if (type == 'longitude' && (coordinate < -180 || coordinate > 180)) {
      return 'Longitude must be between -180 and 180';
    }
    if (type == 'latitude' && (coordinate < -90 || coordinate > 90)) {
      return 'Latitude must be between -90 and 90';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fishing Spot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter spot name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: getLocation, child: Text('Get Location')),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                  hintText: 'Enter longitude (-180 to 180)',
                  suffixText: '°',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateCoordinate(value, 'longitude'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                  hintText: 'Enter latitude (-90 to 90)',
                  suffixText: '°',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateCoordinate(value, 'latitude'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Fishing Spot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
