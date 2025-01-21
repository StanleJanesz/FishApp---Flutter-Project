import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Pages/more_page.dart';
import 'package:fish_app/Services/location_service.dart';
import 'package:fish_app/Services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Pages/add_fish_page.dart';
import 'package:fish_app/Pages/user_page.dart';
import 'package:fish_app/Pages/home_page.dart';
import 'package:fish_app/Pages/statistics_page.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:weather/weather.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fish_app/Services/database_service.dart';

//import 'package:fl_chart/fl_chart.dart';
void main() async  {
  runApp(MyApp());
  WeatherService weatherService = WeatherService();
  Weather? weather = await weatherService.GetWeatherOnline();
  print(weather);
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
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _currentIndex = 0;
  static List<Fish> fishes = [];
    // Key to access the state of Tab 1 and Tab 2
  static final  GlobalKey<StatisticsPageState> statisticPageKey = GlobalKey();
 // final GlobalKey<Tab2State> tab2Key = GlobalKey();
  // List of tabs and their respective labels and icons
  final List<TabData> _tabs = [
    TabData(tab: HomeTab(), label: 'Home', icon: Icons.home),
    TabData(tab: ProfilePage(), label: 'Profile', icon: Icons.person),
    TabData(tab: StatisticsPage(fishes : fishes, key :statisticPageKey ), label: 'Statistics', icon: Icons.bar_chart),
    TabData(tab: MorePage(), label: 'More', icon: Icons.more_horiz),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _navigateAndReceiveData(BuildContext context) async {
    // Navigate to the second page and await the result when the second page is popped
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage()),
    );

    // Use the result returned from the second page
    
    if (result != null) {
      Fish fish = result;
      if (fishes.isNotEmpty)
      fishes.add(fish);
      else {
        final databseServis = DatabaseServiceFish();
        databseServis.addFish(fish);
        final test = await databseServis.getAll();
        print(test.length);
        fishes = test;
      }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Received: ${fish.size} '),
        ));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex].tab,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.amber,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _tabs.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndReceiveData(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class TabData {
  final Widget tab;
  final String label;
  final IconData icon;

  TabData({required this.tab, required this.label, required this.icon});
}


