import 'package:flutter/material.dart';
import 'package:fish_app/Pages/layout.dart';

//import 'package:fl_chart/fl_chart.dart';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Tabs with FAB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainLayout(),
    );
  }
}

