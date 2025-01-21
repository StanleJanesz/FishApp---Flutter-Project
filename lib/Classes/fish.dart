import 'dart:ffi';

class Fish {
  int id; //
  int size; //
  int type; 
  DateTime date; // 
  String catchedBy; //
  int spotId;
  int baitId;    
  int weatherId;    
Fish({required this.id, required this.size, required this.type, required this.date, required this.catchedBy, required this.spotId, required this.baitId, required this.weatherId});
}
class FishType {
  String type;
  static final List<String> types = ['Okoń', 'Sum', 'Leszcz', 'Szczupak'];
  FishType({required this.type});  
}
