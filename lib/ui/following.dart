import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/item.dart';
import './userdetail.dart';
import '../constant.dart' as Constants;

class FollowingPage extends StatelessWidget {
  final String username;

  FollowingPage(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: this.username + '  Following'),
    );
  }
}

// https://flutter.dev/docs/catalog/samples/basic-app-bar
const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share', icon: Icons.share),
  const Choice(title: 'Exit', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Choice _selectedChoice = choices[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _getGitFollowing(widget.title),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
                            contentPadding: const EdgeInsets.all(4.0),
                            title: Text(snapshot.data[index].login),
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
    );
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      if (_selectedChoice.title.toString() == "Share") {
        _onWillPop();
      } else if (_selectedChoice.title.toString() == "Exit") {
        _onWillPop();
      }
    });
  }

  // https://stackoverflow.com/questions/49356664/how-to-override-the-back-button-in-flutter
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Future<List<Item>> _getGitFollowing(username) async {
    username = username.toString().replaceAll(' Following', '');
    try {
      List<Item> users = [];
      var response = await http.get(
          Constants.BaseURL + 'users/' + username + '/following?per_page=100');

      var aObj = json.decode(response.body);
//      print(aObj);
      for (var user in aObj) {
        Item newUser = Item(user["avatar_url"], user["login"], '0');
        users.add(newUser);
      }
      return users;
    } on SocketException catch (_) {
      print('not connected');
      final snackBar = SnackBar(
        content: Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getGitFollowing(username);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
