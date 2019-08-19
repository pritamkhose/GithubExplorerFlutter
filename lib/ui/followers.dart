import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/item.dart';
import '../utility/utility.dart';
import './userdetail.dart';
import '../constant.dart' as Constants;

class FollowersPage extends StatelessWidget {
  final String username;

  FollowersPage(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: this.username),
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
  Choice _selectedChoice = choices[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title  + ' Followers'),
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
              future: _getGitFollowers(widget.title),
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
        Utility().shareURL(context, widget.title);
      } else if (_selectedChoice.title.toString() == "Exit") {
        Utility().onWillPop(context);
      }
    });
  }


  @override
  Future<List<Item>> _getGitFollowers(username) async {
    try {
      List<Item> users = [];
      var response = await http.get(
          Constants.BaseURL + 'users/' + username + '/followers?per_page=100');

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
            _getGitFollowers(username);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}


