import 'package:fish_app/Classes/fishing_place.dart';
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







  List<FishingSpotCard> generateCards()
  {
    List<FishingSpotCard> cards = [];
    cards.add(FishingSpotCard());
    cards.add(FishingSpotCard());
    cards.add(FishingSpotCard());

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
        itemExtent: 200,
        scrollDirection: Axis.vertical,
        children: generateCards(),
      ),
    ));
  }
}


class FishingSpotCard extends StatefulWidget
{
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
        print('Card Tapped');
        setState(() {
          
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/fishing_spot.jpg'),
              Text('Fishing Spot Name'),
              Text('Fishing Spot Description'),
              Text('Fishing Spot Description'),
              Text('Fishing Spot Description'),
              Text('Fishing Spot Location'),
              Text('Fishing Spot Rating'),
              selectState( _isSelected),
              
            ],
          ),
        ),
      ),
    );
  }
  Widget selectState(bool isSelected)
  {
    if(isSelected)
    {
      return Container(
        color: Colors.blue,
        child: Text('Selected'),
      );
    }
    else
    {
      return Container(
        color: Colors.white,
      );
    }
  }

  
}



