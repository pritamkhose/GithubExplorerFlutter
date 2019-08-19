import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:connectivity/connectivity.dart';

import '../model/item.dart';
import './userdetail.dart';
import '../utility/utility.dart';
import '../constant.dart' as Constants;

class HomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Github Explorer is Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Github Explorer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// https://flutter.dev/docs/catalog/samples/basic-app-bar
const List<Choice> choices = const <Choice>[
  const Choice(title: 'Exit', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

class _MyHomePageState extends State<MyHomePage> {
//  final _formKey = GlobalKey<FormState>();
  Choice _selectedChoice = choices[0]; // The app's "state".
  var _searchText = "";

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            // overflow menu
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(0).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Please enter some text for Search'),
//                        initialValue: data == null ? '' : data.title,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 2) {
                            return 'Please enter some text and should be 2+ characters long.';
                          }
                        },
                        onSaved: (String value) {
                          _searchText = value;
                        },
                      ),
                    ),
                    Image(
                      image: new AssetImage("assets/images/search80.png"),
                      width: 60,
                      height: 60,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getGitUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          //child: Text("Loading..."),
                          child: CircularProgressIndicator(),
                        ),
                        /* child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new CircularProgressIndicator(),
                            new Text("Loading...")
                          ],
                        ),*/
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => UserDetailPage(
                                              snapshot.data[index])));
                                },
                                title: Text(snapshot.data[index].login),
                                subtitle: Text(
                                    "Score : " + snapshot.data[index].score),
                                leading: Image(
                                    image: NetworkImage(
                                        snapshot.data[index].avatar_url)),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      if (_selectedChoice.title.toString() == "Exit") {
        Utility().onWillPop(context);
      }
    });
  }

  Future<bool> _onWillPop() {
    return Utility().onWillPop(context);
  }

  @override
  Future<List<Item>> _getGitUsers() async {
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    // I am connected to a mobile or wifi network.
//    if (connectivityResult == ConnectivityResult.mobile ||
//        connectivityResult == ConnectivityResult.wifi) {
    try {
      List<Item> users = [];
      var response =
          await http.get(Constants.BaseURL + 'search/users?q=pritam&page=1');

      var aObj = json.decode(response.body);
//    print(aObj["items"][10]["avatar_url"]);
      for (var user in aObj["items"]) {
        Item newUser =
            Item(user["avatar_url"], user["login"], user["score"].toString());
        users.add(newUser);
      }
      return users;
    } on SocketException catch (_) {
      print('not connected');

//    } else {
      final snackBar = SnackBar(
        content: Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getGitUsers();
          },
        ),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
