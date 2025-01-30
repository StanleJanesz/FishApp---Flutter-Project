import 'package:fish_app/Pages/add_types/add_bait_type.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Pages/add_types/add_fish_type.dart';
import 'package:fish_app/Pages/add_types/add_fishing_spot.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  MorePageState createState() => MorePageState();
}

class MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                 Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BaitFormPage()));
              },
              child: Text('add new bait type'),
            ),
            ElevatedButton(
              onPressed: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FishingSpotFormPage()));
              },
              child: Text('add new fishing spot'),
            ),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FishTypeFormPage()));
              },
              child: Text('add new fish type'),
            ),
          ],
        ),
      ),
    );
  }
}
