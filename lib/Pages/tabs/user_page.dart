import 'package:flutter/material.dart';
import 'package:fish_app/Widgets/presentation_widgets/profile_card_widget.dart';
import 'package:fish_app/Widgets/presentation_widgets/border_box.dart';
class FunFucts {
  String name = 'Imie Nazwisko';
  String fact = 'Favorite fishing spot';
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String getName() {
    return 'Imie Nazwisko';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        itemExtent: 200,
        children: [
          ProfileInfoCard(),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'favorite fishing spot',
            otherText: 'Location 1',
          ),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'Bigest fish',
            otherText: 'Fish 1 (100cm)',
          ),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'favorite fish',
            otherText: 'Fish 1 (32 times)',
          ),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'last fish',
            otherText: 'Fish 145 (12.12.2021)',
          ),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'favorite fish',
            otherText: 'Fish 1 (32 times)',
          ),
          BorderedElevatedBox(
            imageUrl: 'assets/images/fish.png',
            text: 'least often fish',
            otherText: 'Fish 12 (1 times)',
          ),
        ],
      ),
    );
  }
}


