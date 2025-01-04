import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fish_app/Classes/fish.dart';
class DatabaseService{
  final Future<Database> database;
 static Future<Database>  _open  () async
 {

   WidgetsFlutterBinding.ensureInitialized();
   return openDatabase(
       join(await getDatabasesPath(), 'fish_app_database.db'),
   onCreate: (db, version) {
 return db.execute(
 'CREATE TABLE fish(id INTEGER PRIMARY KEY, size INTEGER, type INTEGER, date DATETIME, catchedBy TEXT )',
 );
 },

   version: 1,
   );

 }


   DatabaseService() : database =  _open();

  Future<bool> addFish(Fish fish) async
  {
    final db = await database;

    await db.insert(
      'fish',
      {
        'size' : fish.size,
        'type' : 1,
        'date' : DateTime.now().toIso8601String(),
        'catchedBy' : fish.catchedBy,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<Fish>> getAll() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('fish');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
      'id': id as int,
      } in dogMaps)
        Fish()
    ];
  }
}




class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });
}