
class PartyName{
  String name;
  String id; // it is account id acc_id
  PartyName({required this.id,required this.name});

  String showName(){
    return this.name;
  }
  String getId(){
    return this.id;
  }



}