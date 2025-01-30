import 'package:flutter/material.dart';

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