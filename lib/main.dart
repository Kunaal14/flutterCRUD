//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo2/utils/database_helper.dart';

import 'databaseService/databaseService.dart';
import 'models/contact.dart';

const darkBlueColor = Color(0xff486579);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQlite CRUD',
      theme: ThemeData(
        primaryColor: darkBlueColor,
      ),
      home: MyHomePage(title: 'SQLITE CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DatabaseService _databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  final _ctrName = TextEditingController();
  final _ctrMobile = TextEditingController();
  String controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ctrName,
                decoration: InputDecoration(labelText: 'Full Name'),
                onSaved: (val) => setState(() => _contact.name = val),
                validator: (val) =>
                    (val.length == 0 ? 'This Field is required' : null),
              ),
              TextFormField(
                controller: _ctrMobile,
                decoration: InputDecoration(labelText: 'Mobile'),
                onSaved: (val) => setState(() => _contact.mobile = val),
                validator: (val) =>
                    (val.length < 6 ? 'Provide Correct number' : null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Submit'),
                  color: darkBlueColor,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  _refreshContactList() async {
    //List<Contact> x = await _dbHelper.fetchContacts();
    List<Contact> x = await _databaseService.fetchContact();

    setState(() {
      _contacts = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_contact.name);

      if (_contact.id == null)
        await _databaseService.insertContact(_contact.name, _contact.mobile);
      else
        await _databaseService.updateContact(
            _contact.id, _contact.name, _contact.mobile);

      _refreshContactList();
      //form.reset();
      _resetForm();
      _contact = Contact();
      setState(() {
        controller = _ctrName.text.toString();
      });
      print("controller" + controller);
      //fetchList(controller);
    }
  }

  Future<void> fetchList(String controller) async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.contactsDatabase;

    // get all rows
    List<Map> result3 = await db
        .rawQuery('SELECT id FROM contactsTable WHERE name=?', [controller]);

    // print the results
    result3.forEach((row) => print(row));
  }

  _resetForm() {
    setState(() {
      controller = _ctrName.text.toString();
      print("Controller: " + controller);
      _formKey.currentState.reset();
      _ctrName.clear();
      _ctrMobile.clear();
      _contact.id = null;
      fetchList(controller);
    });
  }

  _list() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: darkBlueColor,
                      size: 40.0,
                    ),
                    title: Text(
                      _contacts[index].name.toUpperCase(),
                      style: TextStyle(
                          color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                    //subtitle: Text(_contacts[index].mobile.+ "\nThird Line"),
                    subtitle: Text("First Line \nThird Line"),

                    //isThreeLine: true,

                    trailing: IconButton(
                      icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                      onPressed: () async {
                        await _databaseService
                            .deleteContact(_contacts[index].id);

                        _resetForm();
                        _refreshContactList();
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _contact = _contacts[index];
                        _ctrName.text = _contacts[index].name;
                        _ctrMobile.text = _contacts[index].mobile;
                      });
                    },
                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
            //itemCount: _contacts.length,
          ),
        ),
      );
}
