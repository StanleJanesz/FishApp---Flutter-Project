import 'package:flutter/material.dart';

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

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Row(
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
              child: Image.asset(
                'assets/images/profile.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )),
          Column(
            children: [
              Text('Name: User Name'),
              Text('Other: Other'),
              Text('Other: Other'),
              Text('Other: Other'),
            ],
          )
        ],
      ),
    );
  }
}

class BorderedElevatedBox extends StatefulWidget {
  final String imageUrl;
  final String text;
  final String otherText;

  const BorderedElevatedBox({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.otherText,
  });

  @override
  State<BorderedElevatedBox> createState() => _BorderedElevatedBoxState();
}

class _BorderedElevatedBoxState extends State<BorderedElevatedBox> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: _isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isSelected ? widget.otherText : widget.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
