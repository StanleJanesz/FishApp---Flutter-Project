import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Classes/weather.dart';
import 'package:fish_app/Widgets/presentation_widgets/fish_details.dart';

class FishingSpotCard extends StatefulWidget {
  final FishingSpot fishingSpot;
  final List<Fish> fishList;
  final Map<int, Bait> baits;
  final Map<int, FishType> fishTypes;
  final Map<int, WeatherLocal> weathers;
  const FishingSpotCard(
      {super.key,
      required this.fishingSpot,
      required this.fishList,
      required this.weathers,
      required this.baits,
      required this.fishTypes});
  @override
  FishingSpotCardState createState() => FishingSpotCardState();
}

class FishingSpotCardState extends State<FishingSpotCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isSelected = !_isSelected;
        setState(() {});
      },
      child: selectState(_isSelected),
    );
  }

  Widget selectState(bool isSelected) {
    if (!isSelected) {
      return Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/location.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Text('Fishing Spot Name'),
              Text(widget.fishingSpot.name),
              Text('${widget.fishList.length} Fish'),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Scaffold(
              backgroundColor: Color.fromARGB(0, 33, 33, 175),
              appBar: AppBar(
                title: Text('Fishing Spot Hisotry'),
              ),
              body: Container(
                margin: EdgeInsets.all(5),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: generateFishHistory(),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  List<Widget> generateFishHistory() {
    List<Widget> fishHistory = [];
    widget.fishList.sort((a, b) => a.date.compareTo(b.date));
    Map<String, List<Fish>> byDates = {};
    for (final fish in widget.fishList) {
      String date = "${fish.date.day}.${fish.date.month}.${fish.date.year}";
      if (byDates.containsKey(date)) {
        byDates[date]!.add(fish);
      } else {
        byDates[date] = [fish];
      }
    }
    for (final date in byDates.keys) {
      fishHistory.add(Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              date,
              style: TextStyle(color: Colors.white),
            ),
          )));

      for (final fish in byDates[date]!) {
        fishHistory.add(FishDetailsCard(
            fish: fish,
            weather: widget.weathers[fish.weatherId],
            bait: widget.baits[fish.baitId],
            fishType: widget.fishTypes[fish.type]));
      }
    }
    return fishHistory;
  }

  Map<String, List<Fish>> mapFish() {
    Map<String, List<Fish>> fishMap = {};
    for (final fish in widget.fishList) {
      if (fishMap.containsKey(fish.type.toString())) {
        fishMap[fish.type.toString()]!.add(fish);
      } else {
        fishMap[fish.type.toString()] = [fish];
      }
    }
    return fishMap;
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: ListView(
          itemExtent: double.infinity,
        ),
      ),
    );
  }
}

