import 'package:flutter/material.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:fish_app/Classes/bait.dart';

class BaitFormPage extends StatefulWidget {
  const BaitFormPage({super.key});

  @override
  State<BaitFormPage> createState() => _BaitFormPageState();
}

class _BaitFormPageState extends State<BaitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      final bait = Bait(
        id: 0,
        name: _nameController.text,
        typeId: 0,
        weight: double.parse(_weightController.text),
      );
      DatabaseServiceBait databaseServiceBait = DatabaseServiceBait();
      databaseServiceBait.addBait(bait);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bait saved successfully!')),
      );

      _nameController.clear();
      _weightController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bait'),
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
                  hintText: 'Enter bait name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  border: OutlineInputBorder(),
                  suffixText: 'g',
                  hintText: 'Enter weight in grams',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Please enter a valid number';
                  }
                  if (weight <= 0) {
                    return 'Weight must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Bait'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
