import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:connectivity/connectivity.dart';

import '../model/item.dart';
import './userdetail.dart';
import '../utility/utility.dart';
import '../constant.dart' as constants;

class HomeApp extends StatelessWidget {
  const HomeApp({Key? key}) : super(key: key);

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
      home: const MyHomePage(title: 'Github Explorer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// https://flutter.dev/docs/catalog/samples/basic-app-bar
const List<Choice> choices = <Choice>[
  Choice(title: 'Exit', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  Choice _selectedChoice = choices[0]; // The app's "state".
  String _searchText = "android";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Item> data = [];

  // https://kodestat.gitbook.io/flutter/flutter-listview-with-json-or-list-data
  Future<String?> _getGitUsers() async {
    //    var connectivityResult = await (Connectivity().checkConnectivity());
//    // I am connected to a mobile or wifi network.
//    if (connectivityResult == ConnectivityResult.mobile ||
//        connectivityResult == ConnectivityResult.wifi) {
    try {
      var response = await http.get(Uri.parse(
          constants.BaseURL + 'search/users?q=' + _searchText + '&page=1'));
      var aObj = json.decode(response.body);
      // print(aObj["items"]);
      List<Item> aData = [];
      for (var user in aObj["items"]) {
        Item newUser =
            Item(user["avatar_url"], user["login"], user["score"].toString());
        aData.add(newUser);
      }
      if (aData.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Search Found!")));
      }
      setState(() {
        data = aData;
      });
      return "Success!";
    } on SocketException catch (_) {
      // print('not connected');
      final snackBar = SnackBar(
        content: const Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getGitUsers();
          },
        ),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
    _getGitUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Utility().showExitDialog(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          // brightness: Brightness.light,           systemOverlayStyle: Brightness.light,
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
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText:
                                        'Please enter username for search'),
                                initialValue: '',
                                validator: (String? value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 2) {
                                    return 'Please enter username and should be 2+ characters long.';
                                  } else {
                                    _searchText = value;
                                    _getGitUsers();
                                    return '';
                                  }
                                },
                                onSaved: (String? value) {
                                  // print('onSaved ' + value!);
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (String value) {
                                  _formKey.currentState!.validate();
                                }),
                          ),
                          GestureDetector(
                              onTap: () {
                                // close Keyboard - https://stackoverflow.com/questions/51652897/how-to-hide-soft-input-keyboard-on-flutter-after-clicking-outside-textfield-anyw
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _formKey.currentState!.validate();
                              },
                              child: const Image(
                                image: AssetImage("assets/images/search80.png"),
                                width: 60,
                                height: 60,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _getGitUsers,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailPage(user: data[index])));
                          },
                          title: Text(data[index].login),
                          subtitle:
                              Text("Score : " + data[index].score.toString()),
                          leading: Image(
                              image: NetworkImage(data[index].avatar_url)),
                        ),
                      );
                    },
                  ),
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
        Utility().showExitDialog(context);
      }
    });
  }
}
