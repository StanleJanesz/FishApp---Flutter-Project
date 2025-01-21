import 'package:flutter/material.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:fish_app/Classes/bait_types.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/fishing_place.dart';
class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
                DatabaseServiceBaitType databaseServiceBaitTypes = DatabaseServiceBaitType();
                databaseServiceBaitTypes.addBaitType(BaitType(name: 'Bait Type 1',id: 1));
              },
              child: Text('addd bait type 1'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseServiceBait databaseServiceBait = DatabaseServiceBait();
                databaseServiceBait.addBait(Bait(name: 'Bait 1',id: 1,typeId: 1,weight: 1));
              },
              child: Text('Butadd baitton 2'),
            ),
             ElevatedButton(
              onPressed: () {
                DatabaseServiceFishingSpot databaseServiceLocation = DatabaseServiceFishingSpot();
                databaseServiceLocation.addFishingSpot(FishingSpot(name: 'Location 1',id: 1,latitude: 1,longitude: 1));
              },
              child: Text('add location 2'),
            ),
             ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Button 2'),
            ),
          ],
        ),
      ),
    );
  }
}