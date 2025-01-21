class Bait {
  int id;
  String name;
  int typeId;
  double weight;

  Bait({required this.id, required this.name, required this.typeId, required this.weight});

  void displayInfo() {
    print('Bait Name: $name');
    print('Type: type');
    print('Weight: ${weight}g');
  }
}