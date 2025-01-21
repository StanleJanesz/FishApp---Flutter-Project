import 'dart:async';
import 'package:fish_app/Classes/fishing_place.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:fish_app/Classes/bait_types.dart';
abstract class DatabaseService{
 Future<Database> get database;
 Future<Database>  _openDatabase  () ;


  //Future<bool> add(Object object) ;

//Future<List<Fish>> getAll() ;
 
}
 class DatabaseServiceFishingSpot implements DatabaseService{
  @override
  late Future<Database> database;
  DatabaseServiceFishingSpot() {
    database = _openDatabase();
  }
  @override 
  Future<Database>  _openDatabase  () async{
      WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'fish_app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE fishingSpotTable(id INTEGER PRIMARY KEY, name TEXT, latitude DOUBLE, longitude DOUBLE)',
        );
      },

      version: 1,
    );
  }
  Future<bool> add(FishingSpot fishingSpot) async
  {
    final db = await database;

    await db.insert(
      'fishingSpotTable',
      {
        'name' : fishingSpot.name,
        'latitude' : fishingSpot.latitude,
        'longitude' : fishingSpot.longitude,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }



  Future<bool> addFishingSpot(FishingSpot fishingSpot) async
  {
    final db = await database;

    await db.insert(
      'fishingSpotTable',
      {
        'name' : fishingSpot.name,
        'latitude' : fishingSpot.latitude,
        'longitude' : fishingSpot.longitude,
      },
    
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<FishingSpot>> getAll() async {

    final db = await database  ;

    final List<Map<String, Object?>> fishMaped = await db.query('fishingSpotTable');

    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'latitude': latitude as double,
      'longitude': longitude as double,
      } in fishMaped)
        FishingSpot(
          id: id,
          name: name,
          latitude: latitude,
          longitude: longitude,
        )
     
    ];
  }


}

class DatabaseServiceFish implements DatabaseService
{
  @override
  late Future<Database> database;
  @override
  Future<Database>  _openDatabase  () async
 {

   WidgetsFlutterBinding.ensureInitialized();
   return openDatabase(
       join(await getDatabasesPath(), 'fish_app_database.db'),
   onCreate: (db, version) {
 return db.execute(
 'CREATE TABLE fish(id INTEGER PRIMARY KEY, size INTEGER, type INTEGER, date DATETIME, catchedBy TEXT, spotId INTEGER, baitId INTEGER, weatherId INTEGER)',
 );
 },

   version: 1,
   );

 }
  

   DatabaseServiceFish() 
   {
      database = _openDatabase();
   }

  Future<bool> addFish(Fish fish) async
  {
    final db = await database;

    await db.insert(
      'fish',
      {
        'size' : fish.size,
        'type' : fish.type,
        'date' : DateTime.now().toIso8601String(),
        'catchedBy' : fish.catchedBy,
        'spotId' : fish.spotId,
        'baitId' : fish.baitId,
        'weatherId' : fish.weatherId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<Fish>> getAll() async {

    final db = await database  ;

    final List<Map<String, Object?>> fishMaped = await db.query('fish');

    return [
      for (final {
      'id': id as int,
      'size': size as int,
      'type': type as int,
      'date': date as String,
      'catchedBy': catchedBy as String,
      'spotId': spotId as int,
      'baitId': baitId as int,
      'weatherId': weatherId as int,
      } in fishMaped)
        Fish(
          id: id,
          size: size,
          type: type,
          date: DateTime.parse(date),
          catchedBy: catchedBy,
          spotId: spotId,
          baitId: baitId,
          weatherId: weatherId,
        )
    ];
  }
}

class DatabaseServiceFishType implements DatabaseService
{
  @override
  late Future<Database> database;
  DatabaseServiceFishType() {
    database = _openDatabase();
  }
  @override
  Future<Database>  _openDatabase  () async
  {

    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'fish_app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE fishType(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },

      version: 1,
    );
  }
  
  Future<bool> addFishType(FishType fishType) async
  {
    final db = await database;

    await db.insert(
      'fishType',
      {
        'type' : fishType.type,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<FishType>> getAll() async {

    final db = await database  ;

    final List<Map<String, Object?>> fishTypeMaped = await db.query('fishType');

    return [
      for (final {
      'name': type as String,
      } in fishTypeMaped)
        FishType(type: type)
    ];
  }
}

class DatabaseServiceBait implements DatabaseService
{
  @override
  late Future<Database> database;
  DatabaseServiceBait() 
  {
    database = _openDatabase();
  }
  @override
  Future<Database>  _openDatabase  () async
  {

    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'fish_app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bait(id INTEGER PRIMARY KEY, name TEXT, type INTEGER,weight DOUBLE)',
        );
      },

      version: 1,
    );
  }

   Future<bool> addBait(Bait bait) async
  {
    final db = await database;

    await db.insert(
      'bait',
      {
        'name' : bait.name,
        'type' : bait.typeId,
        'weight' : bait.weight,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<Bait>> getAll() async {

    final db = await database  ;

    final List<Map<String, Object?>> fishTypeMaped = await db.query('bait');

    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'type': type as int,
      'weight': weight as double,
      } in fishTypeMaped)
        Bait(name: name, typeId: type, weight: weight,id: id)
       
        
    ];
  }
}
class DatabaseServiceBaitType implements DatabaseService
{
  @override
  late Future<Database> database;


  DatabaseServiceBaitType() {
    database = _openDatabase();
  }
  @override
  Future<Database>  _openDatabase  () async
  {

    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'fish_app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE baitType(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },

      version: 1,
    );
  }

  Future<bool> addBaitType(BaitType baitType) async
  {
    final db = await database;

    await db.insert(
      'baitType',
      {
        'name' : baitType.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }


  Future<List<BaitType>> getAll() async {

    final db = await database  ;

    final List<Map<String, Object?>> fishTypeMaped = await db.query('baitType');

    return [
      for (final {
      'id': id as int,
      'name': name as String,
      } in fishTypeMaped)
      BaitType(name: name, id: id)
     
       
        
    ];
  }
}

