import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_demo2/config/databaseConfig.dart';
import 'package:sqlite_demo2/models/contact.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _contactsDatabase;

  //*****************************************************//

  Future<Database> get contactsDatabase async {
    if (_contactsDatabase != null) return _contactsDatabase;
    _contactsDatabase = await _initDatabase();
    return _contactsDatabase;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(dataDirectory.path, DatabaseConfig.dbName);
    return await openDatabase(dbPath,
        version: DatabaseConfig.databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute(DatabaseConfig.contactTableQueryV1);
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await contactsDatabase;
    return await db.insert(ContactTableConfig.tblContact, contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await contactsDatabase;
    //print(await db.query("contactsTable"));
    return await db.update(ContactTableConfig.tblContact, contact.toMap(),
        where: '${ContactTableConfig.colId} = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(String id) async {
    Database db = await contactsDatabase;
    //print(await db.query("contactsTable"));
    return await db.delete(ContactTableConfig.tblContact,
        where: '${ContactTableConfig.colId} = ?', whereArgs: [id]);
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await contactsDatabase;
    List<Map> contacts = await db.query(ContactTableConfig.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
