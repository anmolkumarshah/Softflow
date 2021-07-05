import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';

class DO {
  PartyName party;
  String doNumber;
  DateTime dateTime;
  Station fromStation;
  Station toStation;
  Product product;
  String quantity;
  PartyName consignee;
  PartyName consecd;
  PartyName broker;
  Truck truck;

  DO({
    required this.product,
    required this.dateTime,
    required this.broker,
    required this.consecd,
    required this.consignee,
    required this.doNumber,
    required this.fromStation,
    required this.party,
    required this.quantity,
    required this.toStation,
    required this.truck,
  });

  void display(){
    print(this.product.showName());
    print(this.dateTime);
    print(this.doNumber);
    print(this.fromStation.showName());
    print(this.toStation.showName());
    print(this.product.showName());
    print(this.quantity);
    print(this.consignee.showName());
    print(this.consecd.showName());
    print(this.truck.getNo());
  }
}
