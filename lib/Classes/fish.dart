class Fish {
  int id;
  int size;
  FishType type;
  DateTime date;
  String catchedBy;
  Fish()
      : size = 0,
        type = FishType(),
        date = DateTime.now(),
        catchedBy = "User",
        id = 0;
}

class FishType {
  String type;
  static final List<String> types = ['Okoń', 'Sum', 'Leszcz', 'Szczupak'];
  FishType() : type = "Okoń";
}
