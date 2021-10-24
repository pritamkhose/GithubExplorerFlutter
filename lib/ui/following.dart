import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/item.dart';
import '../utility/utility.dart';
import './userdetail.dart';
import '../constant.dart' as constants;

class FollowingPage extends StatelessWidget {
  final String username;

  const FollowingPage({key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: username),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title}) : super(key: key);

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
        title: Text(widget.title + ' Following'),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDetailPage(user:
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
        Utility().showExitDialog(context);
      }
    });
  }

  Future<List<Item>?> _getGitFollowing(username) async {
    try {
      List<Item> users = [];
      var response = await http.get(Uri.parse(
          constants.BaseURL + 'users/' + username + '/following?per_page=100'));

      var aObj = json.decode(response.body);
//      print(aObj);
      for (var user in aObj) {
        Item newUser = Item(user["avatar_url"], user["login"], '0');
        users.add(newUser);
      }
      return users;
    } on SocketException catch (_) {
      // print('not connected');
      final snackBar = SnackBar(
        content: const Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getGitFollowing(username);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
