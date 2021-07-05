class Truck{
  String uid;
  String truckNo;
  String panNo;

  Truck({required this.panNo,required this.truckNo,required this.uid});

  String getNo(){
    return this.truckNo;
  }

  String getId(){
    return this.uid;
  }
}