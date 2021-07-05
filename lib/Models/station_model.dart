class Station{
  String id;
  String name;
  Station({required this.id, required this.name});

  String showName(){
    return this.name;
  }
  String getId(){
    return this.id;
  }
}