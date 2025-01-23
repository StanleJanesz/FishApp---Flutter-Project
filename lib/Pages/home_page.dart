import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:select_field/select_field.dart';

class HomeTab extends StatefulWidget {


  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {


  String message = 'Home Tab';
  List<FishingSpot> fishingSpots = [];
  Map<int, List<Fish>> fishMap = {};

  
@override
  void initState() {
    super.initState();
    getFromDatabse();
  }
void getFromDatabse() async {
    await getFishMap();
    DatabaseServiceFishingSpot databaseServiceFishingSpot = DatabaseServiceFishingSpot();
    fishingSpots = await databaseServiceFishingSpot.getAll();
    setState(() {
      
    });
}

Future<Map<int, List<Fish>>> getFishMap() async{
    DatabaseServiceFish databaseServiceFish = DatabaseServiceFish();
    for (final spot in fishingSpots) {
      fishMap[spot.id] = await databaseServiceFish.getAllBySpotId(spot.id);
    }
    return fishMap;
  }



  List<FishingSpotCard> generateCards() 
  {
    getFromDatabse();
    List<FishingSpotCard> cards = [];
    for (final spot in fishingSpots)
    {
      cards.add(FishingSpotCard(fishingSpot: spot, fishList: fishMap[spot.id] ?? []));
    }
    return cards;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body:
    
    
     Center(
      child: ListView(
        
        scrollDirection: Axis.vertical,
        children:  generateCards(),
      ),
    ));
  }
}


class FishingSpotCard extends StatefulWidget
{
  final FishingSpot fishingSpot;
  final List<Fish> fishList;
  const FishingSpotCard({super.key, required this.fishingSpot, required this.fishList});
  @override
  _FishingSpotCardState createState() => _FishingSpotCardState();


}


class _FishingSpotCardState extends State<FishingSpotCard>
{
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        _isSelected = !_isSelected;
        setState(() {
        });
      },
      child: selectState(_isSelected),
    );
  }



  Widget selectState(bool isSelected)
  {
    if(!isSelected)
    {
      return Container(
        margin: EdgeInsets.all(10),
        child: Card(
          
          child: Column(
            children: <Widget>[
               Image.network('https://th.bing.com/th/id/OIP.jrtcae1CNzs3q01Td3mhfAHaDt?rs=1&pid=ImgDetMain',
                height: 100,
                width: 100,
                fit: BoxFit.cover,),
              Text('Fishing Spot Name'),
              Text(widget.fishingSpot.name),
              Text(widget.fishList.length.toString() + ' Fish'),
              Text('Fishing Spot Description'),
              Text('Fishing Spot Location'),
              Text('Fishing Spot Rating'),
              
            ],
          ),
        ),
      );
    }
    else
    {
      return Container(
        height: 600,
      margin: EdgeInsets.all(10),
      child: 
      Card( 
        child: Padding(padding: EdgeInsets.all(10),
        
        child : Scaffold(
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

  List<Widget> generateFishHistory()
  {
    var map =  mapFish();
    List<Widget> fishHistory = [];
    widget.fishList.sort((a, b) => a.date.compareTo(b.date));
    Map<String,List<Fish>> byDates  = {};
    for (final fish in widget.fishList)
    {
      String date = "${fish.date.day}.${fish.date.month}.${fish.date.year}";  
      if(byDates.containsKey(date))
      {
        byDates[date]!.add(fish);
      }
      else
      {
        byDates[date] = [fish];
      }
    }
    for (final date in byDates.keys)
    {
      fishHistory.add(
        Container(
  margin: EdgeInsets.all(5),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(5),
  ),
  child:Center(
    child: Text(
    date,
    style: TextStyle(color: Colors.white),
  ),
)));

      for (final fish in byDates[date]!)
      {
        fishHistory.add(FishDetailsCard(fish: fish));
      }
    }
    return fishHistory;                                                 
  }
  Map<String,List<Fish>> mapFish()
  {
    Map<String,List<Fish>> fishMap = {};
    for (final fish in widget.fishList)
    {
      if(fishMap.containsKey(fish.type.toString()))
      {
        fishMap[fish.type.toString()]!.add(fish);
      }
      else
      {
        fishMap[fish.type.toString()] = [fish];
      }
    }
    return fishMap;
  }
}
class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        height: 200,
        child:  ListView(
          itemExtent: double.infinity,
  
      ),),
      
      );
    
  }
}




///////////////////////////////////////////////
class FishDetailsCard extends StatelessWidget {
  final Fish fish;
  
  const FishDetailsCard({
    Key? key,
    required this.fish,
  }) : super(key: key);

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
            _buildDetail('Type', '${fish.type}'),
            _buildDetail('Date', '${fish.date.day}/${fish.date.month}/${fish.date.year}'),
            _buildDetail('Bait', '${fish.baitId}'),
            _buildDetail('Weather', '${fish.weatherId}'),
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
