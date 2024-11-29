class Fish {
  int size;
  FishType type;
  DateTime date;
  String catchedBy;
  Fish()
      : size = 0,
        type = FishType(),
        date = DateTime.now(),
        catchedBy = "User";
}

class FishType {
  String type;
  List<String> types = ['Okoń', 'Sum', 'Leszcz', 'Szczupak'];
  FishType() : type = "Okoń";
}
