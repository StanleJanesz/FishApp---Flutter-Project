import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example state variables to hold profile information
  String name = 'John Doe';
  String email = 'johndoe@example.com';
  String profilePictureUrl = 'https://www.example.com/profile_picture.jpg';
  String bio = 'Software Developer | Flutter Enthusiast | Tech Lover';

  // Method to update profile information (e.g., change name or bio)
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
              // Open an edit screen or show a dialog to change profile
              showDialog(
                context: context,
                builder: (context) => EditProfileDialog(
                  onUpdate: updateProfile,
                ),
              );
            },
          ),
        ],
      ),
      
    );
  }
}

// A dialog to edit profile info
class EditProfileDialog extends StatefulWidget {
  final Function(String, String) onUpdate;

  const EditProfileDialog({super.key, required this.onUpdate});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _bioController,
            decoration: InputDecoration(labelText: 'Bio'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Call the onUpdate callback to update the profile
            widget.onUpdate(_nameController.text, _bioController.text);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
