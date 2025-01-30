import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Classes/weather.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
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
        height: 600,
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

///////////////////////////////////////////////
class FishDetailsCard extends StatelessWidget {
  final Fish fish;
  final WeatherLocal? weather;
  final Bait? bait;
  final FishType? fishType;
  const FishDetailsCard({
    super.key,
    required this.fish,
    required this.weather,
    required this.bait,
    required this.fishType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fish #${fish.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetail('Size', '${fish.size} cm'),
            if (fishType != null) _buildDetail('Bait', fishType?.type ?? ''),
            _buildDetail('Date',
                '${fish.date.day}/${fish.date.month}/${fish.date.year}'),
            if (bait != null) _buildDetail('Bait', bait?.name ?? ''),
            if (weather != null)
              _buildDetail('Weather',
                  '${weather?.temperature.round()}°C, ${weather?.description}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
