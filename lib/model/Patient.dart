class Patients{
  int id;

  String name;
  String mobileNo;
  String age;

  bool isDone = false;

  Patients({this.id,this.name,this.mobileNo,this.age,this.isDone=false});

  factory Patients.fromDatabaseJson(Map<String, dynamic> data) => Patients(
    id: data['id'],
    name: data['name'],
    mobileNo: data['mobileNo'],
    age: data['age'],
    isDone: data['is_done'] == 0 ? false : true,
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "name": this.name,
    "mobileNo": this.mobileNo,
    "age": this.age,
    "is_done": this.isDone == false ? 0 : 1,
  };
}