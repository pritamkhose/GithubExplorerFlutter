import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/user_repos.dart';
import '../utility/utility.dart';
import '../constant.dart' as Constants;

class RepositoryPage extends StatelessWidget {
  final String username;

  RepositoryPage(this.username);

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
        title: Text(widget.title + ' Repository'),
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
              future: _getGitRepository(widget.title),
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
                              Utility().launchURL(
                                  context, snapshot.data[index].html_url);
                            },
//                            contentPadding: const EdgeInsets.all(2.0),
                            title: Text(
                              snapshot.data[index].name != null
                                  ? snapshot.data[index].name
                                  : '',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Visibility(
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 6),
                                  ),
                                  visible:
                                      snapshot.data[index].description != null,
                                ),
                                Visibility(
                                  child: Text(
                                    snapshot.data[index].description != null
                                        ? snapshot.data[index].description
                                        : '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  visible:
                                      snapshot.data[index].description != null,
                                ),
                                Text(
                                  '',
                                  style: TextStyle(fontSize: 6),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot.data[index].language != null
                                            ? snapshot.data[index].language
                                            : '',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 14),
                                      ),
                                    ),
                                    Image(
                                      image: new AssetImage(
                                          "assets/images/star80.png"),
                                      width: 20,
                                      height: 20,
                                      color: null,
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    ),
                                    Text(
                                      '  ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      snapshot.data[index].stargazers_count !=
                                              null
                                          ? snapshot
                                              .data[index].stargazers_count
                                              .toString()
                                          : '0',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    Text(
                                      '     ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Image(
                                      image: new AssetImage(
                                          "assets/images/codefork96.png"),
                                      width: 20,
                                      height: 20,
                                      color: null,
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    ),
                                    Text(
                                      '  ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      snapshot.data[index].forks != null
                                          ? snapshot.data[index].forks
                                              .toString()
                                          : '0',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    )
                                  ],
                                )
                              ],
                            ),
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
  Future<List<UserRepos>> _getGitRepository(username) async {
    try {
      List<UserRepos> repos = [];
      var response = await http.get(Constants.BaseURL +
          'users/' +
          username +
          '/repos?sort=updated&per_page=100');

      var aObj = json.decode(response.body);
      for (var repo in aObj) {
//        print(repo);
        UserRepos newRepos = UserRepos(
            repo["name"],
            repo["owner"]["login"],
            repo['description'],
            repo["html_url"],
            repo["language"],
            repo["stargazers_count"],
            repo["forks"]);
        repos.add(newRepos);
      }
      return repos;
    } on SocketException catch (_) {
      print('not connected');
      final snackBar = SnackBar(
        content: Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getGitRepository(username);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
