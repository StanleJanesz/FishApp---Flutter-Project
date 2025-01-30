import 'package:flutter/material.dart';
import 'package:fish_app/Classes/fish.dart';

import 'package:fish_app/Services/database_service.dart';

class FishTypeFormPage extends StatefulWidget {
  const FishTypeFormPage({super.key});

  @override
  State<FishTypeFormPage> createState() => _FishTypeFormPageState();
}

class _FishTypeFormPageState extends State<FishTypeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final fishType = FishType(
        id: int.parse(_idController.text),
        type: _typeController.text,
      );

      DatabaseServiceFishType databaseServiceFishType =
          DatabaseServiceFishType();
      databaseServiceFishType.addFishType(fishType);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fish type saved successfully!')),
      );
      _idController.clear();
      _typeController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Fish Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Fish Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a fish type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Fish Type'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
