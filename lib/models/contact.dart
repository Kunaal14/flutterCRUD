import 'package:sqlite_demo2/config/databaseConfig.dart';

class Contact {
  Contact({this.id, this.name, this.mobile});

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[ContactTableConfig.colId];
    name = map[ContactTableConfig.colName];
    mobile = map[ContactTableConfig.colMobile];
  }
  //int id;
  String id;
  String name;
  String mobile;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ContactTableConfig.colName: name,
      ContactTableConfig.colMobile: mobile
    };
    if (id != null) map[ContactTableConfig.colId] = id;
    return map;
  }
}
