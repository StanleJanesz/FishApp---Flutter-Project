import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Classes/weather.dart';
import 'package:fish_app/Widgets/presentation_widgets/fishing_spot_card.dart';
class LocationsTab extends StatefulWidget {
  const LocationsTab({super.key});

  @override
  LocationsTabState createState() => LocationsTabState();
}

class LocationsTabState extends State<LocationsTab> {
  String message = 'Home Tab';
  List<FishingSpot> fishingSpots = [];
  Map<int, List<Fish>> fishMap = {};
  Map<int, WeatherLocal> weathers = {};
  Map<int, FishType> fishTypes = {};
  Map<int, Bait> baits = {};

  @override
  void initState() {
    super.initState();
    getFromDatabse();
  }

  void getFromDatabse() async {
    DatabaseServiceFishingSpot databaseServiceFishingSpot =
        DatabaseServiceFishingSpot();
    fishingSpots = await databaseServiceFishingSpot.getAll();
    getFishTypes();
    getBaits();
    await getFishMap();
    await getWeatherMap();

    setState(() {});
  }

  Future<Map<int, List<Fish>>> getFishMap() async {
    DatabaseServiceFish databaseServiceFish = DatabaseServiceFish();
    for (final spot in fishingSpots) {
      fishMap[spot.id] = await databaseServiceFish.getAllBySpotId(spot.id);
    }
    return fishMap;
  }

  Future<Map<int, FishType>> getFishTypes() async {
    DatabaseServiceFishType databaseServiceFishType = DatabaseServiceFishType();
    List<FishType> fishTypesList = await databaseServiceFishType.getAll();
    for (final fishType in fishTypesList) {
      fishTypes[fishType.id] = fishType;
    }
    return fishTypes;
  }

  Future<Map<int, Bait>> getBaits() async {
    DatabaseServiceBait databaseServiceBait = DatabaseServiceBait();
    List<Bait> baitsList = await databaseServiceBait.getAll();
    for (final bait in baitsList) {
      baits[bait.id] = bait;
    }
    return baits;
  }

  Future<Map<int, WeatherLocal>> getWeatherMap() async {
    DatabseServiceWeather databaseServiceWeather = DatabseServiceWeather();
    for (final fishList in fishMap.values) {
      for (final fish in fishList) {
        if (!weathers.containsKey(fish.weatherId)) {
          weathers[fish.weatherId] =
              await databaseServiceWeather.getWeatherById(fish.weatherId);
        }
      }
    }
    return weathers;
  }

  List<FishingSpotCard> generateCards() {
    getFromDatabse();
    List<FishingSpotCard> cards = [];
    for (final spot in fishingSpots) {
      cards.add(FishingSpotCard(
          fishingSpot: spot,
          fishList: fishMap[spot.id] ?? [],
          weathers: weathers,
          baits: baits,
          fishTypes: fishTypes));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: generateCards(),
          ),
        ));
  }
}
