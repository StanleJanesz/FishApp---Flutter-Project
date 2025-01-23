import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example state variables to hold profile information
  String name = 'John Doe';
  String profilePictureUrl = 'https://www.example.com/profile_picture.jpg';
  String bio = 'Software Developer | Flutter Enthusiast | Tech Lover';
  String getName()
  {
    return 'Imie Nazwisko';
  }

  void updateProfile(String newName, String newBio) {
    setState(() {
      name = newName;
      bio = newBio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {

            },
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        itemExtent: 200,
        children: [
          ProfileInfoCard(),
          BorderedElevatedBox(
            imageUrl: 'https://th.bing.com/th/id/OIP.jrtcae1CNzs3q01Td3mhfAHaDt?rs=1&pid=ImgDetMain',
            text:  'jestem koza ',
          ),
          BorderedElevatedBox(
            imageUrl: 'https://th.bing.com/th/id/OIP.jrtcae1CNzs3q01Td3mhfAHaDt?rs=1&pid=ImgDetMain',
            text:  'jestem koza ',
          ),

        ],
      ) ,
    );
  }
}

class ProfileInfoCard extends StatefulWidget
{
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();

}
class _ProfileInfoCardState extends State<ProfileInfoCard>
{
  @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color:  Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow:  [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]

        ),
        child: Row(
          children: [
            Icon(Icons.ice_skating),
            Column(
              children: [
                 Text('Imie: imie czu cos'),
                 Text('Imie: imie czu cos'),
                 Text('Imie: imie czu cos'),
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

  const BorderedElevatedBox({
    super.key,
    required this.imageUrl,
    required this.text,
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
              child: Image.network(
                widget.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
