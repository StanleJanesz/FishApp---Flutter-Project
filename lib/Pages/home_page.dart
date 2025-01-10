import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Example dynamic state variables
  String message = 'Home Tab';

  // Example method to change the message dynamically
  void updateMessage() {
    setState(() {
      message = 'Updated Home Tab Message!';
    });
  }
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: generateCards(),
      ),
    );
  }
}


class FishingSpotCard extends StatefulWidget
{
  @override
  _FishingSpotCardState createState() => _FishingSpotCardState();


}


class _FishingSpotCardState extends State<FishingSpotCard>
{

  @override
  Widget build(BuildContext context) {

    return Text('data');
  }
  }


