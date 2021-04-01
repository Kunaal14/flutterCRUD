import 'package:sqlite_demo2/models/contact.dart';

class DatabaseConfig {
  static const String dbName = 'Contacts.db';
  static const databaseVersion = 1;

  static const String contactTableQueryV1 = '''
    CREATE TABLE ${ContactTableConfig.tblContact}(
      ${ContactTableConfig.colId} TEXT PRIMARY KEY,
      ${ContactTableConfig.colName} TEXT NOT NULL,
      ${ContactTableConfig.colMobile} TEXT NOT NULL 
    )
    ''';
}

class ContactTableConfig {
  static const tblContact = 'contactsTable';

  static const colId = 'id';

  static const colName = 'name';

  static const colMobile = 'mobile';
}
