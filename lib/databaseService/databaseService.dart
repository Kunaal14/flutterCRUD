import 'package:flutter/material.dart';
import 'package:sqlite_demo2/models/contact.dart';
import 'package:sqlite_demo2/utils/database_helper.dart';
import 'package:uuid/uuid.dart';

class DatabaseService extends ChangeNotifier {
  DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Contact contact = Contact();
  Uuid _uuid = Uuid();

  void insertContact(String name, String mobile) {
    var id = _uuid.v1();
    contact.id = id;
    contact.name = name;
    contact.mobile = mobile;
    _dbHelper.insertContact(contact);
  }

  void updateContact(String id, String name, String mobile) {
    contact.id = id;
    contact.name = name;
    contact.mobile = mobile;
    _dbHelper.updateContact(contact);
    print(id);
  }

  void deleteContact(String id) {
    contact.id = id;
    _dbHelper.deleteContact(contact.id);
    print(id);
  }

  List<Contact> fetchContact() {
    List<Contact> x = _dbHelper.fetchContacts() as List<Contact>;
    return x;
  }
}
