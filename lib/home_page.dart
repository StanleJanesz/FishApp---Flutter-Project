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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: updateMessage,
            child: Text('Change Message'),
          ),
        ],
      ),
    );
  }
}
