import 'dart:async';
import 'package:fish_app/Classes/fishing_place.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:fish_app/Classes/bait_types.dart';
import 'package:fish_app/Classes/weather.dart';

abstract class DatabaseService {
  Future<Database> get database;
  Future<Database> _openDatabase();
  static final String databaseName = "fishAppDatabase1.db";
  static Future<void> onCreate(Database database) async {
    var db = database;
    await db.execute(
      'CREATE TABLE fishingSpotTable(id INTEGER PRIMARY KEY, name TEXT, latitude DOUBLE, longitude DOUBLE)',
    );
    await db.execute(
      'CREATE TABLE fishes(id INTEGER PRIMARY KEY, size INTEGER, type INTEGER, date DATETIME, catchedBy TEXT, spotId INTEGER, baitId INTEGER, weatherId INTEGER)',
    );
    await db.execute(
      'CREATE TABLE fishType(id INTEGER PRIMARY KEY, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE bait(id INTEGER PRIMARY KEY, name TEXT, type INTEGER,weight DOUBLE)',
    );
    await db.execute(
      'CREATE TABLE baitType(id INTEGER PRIMARY KEY, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE weather(id INTEGER PRIMARY KEY, temperature DOUBLE, description TEXT, windSpeed DOUBLE, humidity DOUBLE, pressure DOUBLE, windDegree DOUBLE, windGust DOUBLE, cloudiness DOUBLE, rainLastHour DOUBLE, rainLast3Hours DOUBLE, snowLastHour DOUBLE, snowLast3Hours DOUBLE)',
    );
  }
}

class DatabaseServiceFishingSpot implements DatabaseService {
  @override
  late Future<Database> database;
  DatabaseServiceFishingSpot() {
    database = _openDatabase();
  }
  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  Future<bool> add(FishingSpot fishingSpot) async {
    final db = await database;

    await db.insert(
      'fishingSpotTable',
      {
        'name': fishingSpot.name,
        'latitude': fishingSpot.latitude,
        'longitude': fishingSpot.longitude,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<bool> addFishingSpot(FishingSpot fishingSpot) async {
    final db = await database;

    await db.insert(
      'fishingSpotTable',
      {
        'name': fishingSpot.name,
        'latitude': fishingSpot.latitude,
        'longitude': fishingSpot.longitude,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<FishingSpot>> getAll() async {
    final db = await database;

    final List<Map<String, Object?>> fishMaped =
        await db.query('fishingSpotTable');

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

class DatabaseServiceFish implements DatabaseService {
  @override
  late Future<Database> database;

  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  DatabaseServiceFish() {
    database = _openDatabase();
  }

  Future<bool> addFish(Fish fish) async {
    final db = await database;

    await db.insert(
      'fishes',
      {
        'size': fish.size,
        'type': fish.type,
        'date': DateTime.now().toIso8601String(),
        'catchedBy': fish.catchedBy,
        'spotId': fish.spotId,
        'baitId': fish.baitId,
        'weatherId': fish.weatherId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<Fish>> getAll() async {
    final db = await database;

    final List<Map<String, Object?>> fishMaped = await db.query('fishes');

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

  final List<String> filterQueryOptions = [
    'type = ?',
    'spotId = ?',
    'baitId = ?'
  ];
  Future<List<Fish>> getByFilter(List<int> filters) async {
    final db = await database;
    List<String> selectedQueryOptions = [];
    List<int> selectedQueryValues = [];
    for (int i = 0; i < filters.length; i++) {
      if (filters[i] > 0) {
        selectedQueryOptions.add(filterQueryOptions[i]);
        selectedQueryValues.add(filters[i]);
      }
    }
    if (selectedQueryOptions.isEmpty) {
      return getAll();
    }
    final List<Map<String, Object?>> fishMaped = await db.rawQuery(
        'SELECT * FROM fishes WHERE ${selectedQueryOptions.join(' AND ')}',
        selectedQueryValues);
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

  Future<List<Fish>> getAllBySpotId(int id) async {
    final db = await database;

    final List<Map<String, Object?>> fishMaped =
        await db.rawQuery('SELECT * FROM fishes WHERE spotId = ?', [id]);
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

class DatabaseServiceFishType implements DatabaseService {
  @override
  late Future<Database> database;
  DatabaseServiceFishType() {
    database = _openDatabase();
  }
  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  Future<bool> addFishType(FishType fishType) async {
    final db = await database;

    await db.insert(
      'fishType',
      {
        'name': fishType.type,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<FishType>> getAll() async {
    final db = await database;

    final List<Map<String, Object?>> fishTypeMaped = await db.query('fishType');

    return [
      for (final {
            'name': type as String,
            'id': id as int,
          } in fishTypeMaped)
        FishType(type: type, id: id)
    ];
  }
}

class DatabaseServiceBait implements DatabaseService {
  @override
  late Future<Database> database;
  DatabaseServiceBait() {
    database = _openDatabase();
  }
  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  Future<bool> addBait(Bait bait) async {
    final db = await database;

    await db.insert(
      'bait',
      {
        'name': bait.name,
        'type': bait.typeId,
        'weight': bait.weight,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<Bait>> getAll() async {
    final db = await database;

    final List<Map<String, Object?>> fishTypeMaped = await db.query('bait');

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'type': type as int,
            'weight': weight as double,
          } in fishTypeMaped)
        Bait(name: name, typeId: type, weight: weight, id: id)
    ];
  }
}

class DatabaseServiceBaitType implements DatabaseService {
  @override
  late Future<Database> database;

  DatabaseServiceBaitType() {
    database = _openDatabase();
  }
  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  Future<bool> addBaitType(BaitType baitType) async {
    final db = await database;

    await db.insert(
      'baitType',
      {
        'name': baitType.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<BaitType>> getAll() async {
    final db = await database;

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

class DatabseServiceWeather implements DatabaseService {
  @override
  late Future<Database> database;
  DatabseServiceWeather() {
    database = _openDatabase();
  }
  @override
  Future<Database> _openDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), DatabaseService.databaseName),
      onCreate: (db, version) {
        return DatabaseService.onCreate(db);
      },
      version: 1,
    );
  }

  Future<int> addWeather(WeatherLocal weather) async {
    final db = await database;

    int id = await db.insert(
      'weather',
      {
        'temperature': weather.temperature,
        'description': weather.description,
        'windSpeed': weather.windSpeed,
        'humidity': weather.humidity,
        'pressure': weather.pressure,
        'windDegree': weather.windDegree,
        'windGust': weather.windGust,
        'cloudiness': weather.cloudiness,
        'rainLastHour': weather.rainLastHour,
        'rainLast3Hours': weather.rainLast3Hours,
        'snowLastHour': weather.snowLastHour,
        'snowLast3Hours': weather.snowLast3Hours,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<WeatherLocal> getWeatherById(int id) async {
    final db = await database;

    final List<Map<String, Object?>> weatherMaped =
        await db.query('weather', where: 'id = ?', whereArgs: [id]);
    return WeatherLocal(
      id: id,
      temperature: weatherMaped[0]['temperature'] as double,
      description: weatherMaped[0]['description'] as String,
      windSpeed: weatherMaped[0]['windSpeed'] as double,
      humidity: weatherMaped[0]['humidity'] as double?,
      pressure: weatherMaped[0]['pressure'] as double?,
      windDegree: weatherMaped[0]['windDegree'] as double?,
      windGust: weatherMaped[0]['windGust'] as double?,
      cloudiness: weatherMaped[0]['cloudiness'] as double?,
      rainLastHour: weatherMaped[0]['rainLastHour'] as double?,
      rainLast3Hours: weatherMaped[0]['rainLast3Hours'] as double?,
      snowLastHour: weatherMaped[0]['snowLastHour'] as double?,
      snowLast3Hours: weatherMaped[0]['snowLast3Hours'] as double?,
    );
  }
}
