class Product{
  String name;
  String id;
  Product({required this.id,required this.name});

  String showName(){
    return this.name;
  }
  String getId(){
    return this.id;
  }
}