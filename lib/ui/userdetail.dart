import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import '../model/item.dart';
import '../model/user_detail_response.dart';
import '../utility/utility.dart';
import '../constant.dart' as constants;

import './followers.dart';
import './following.dart';
import './repositories.dart';

class UserDetailPage extends StatelessWidget {
  final Item user;

  const UserDetailPage({key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: user.login, userObj: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title, required this.userObj}) : super(key: key);

  final String title;
  final Item userObj;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Choice _selectedChoice = choices[0];

  @override
  Widget build(BuildContext context) {
    Item userObj = widget.userObj;
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
              future: _getUserDetails(widget.title),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      image: NetworkImage(
                                          userObj.avatar_url.toString()),
                                      width: 120,
                                      height: 120,
                                      color: null,
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  snapshot.data.name != null,
                                              child: Text(
                                                snapshot.data.name ?? '',
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 22),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  snapshot.data.bio != null,
                                              child: const Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible:
                                                  snapshot.data.bio != null,
                                              child: Text(
                                                  snapshot.data.bio ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                            Visibility(
                                              visible: snapshot.data.location !=
                                                  null,
                                              child: const Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible: snapshot.data.location !=
                                                  null,
                                              child: Text(
                                                  snapshot.data.location ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                            Visibility(
                                              visible: (userObj.score != null && userObj.score != '0'),
                                              child: const Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible: (userObj.score != null && userObj.score != '0'),
                                              child: Text(
                                                  userObj.score != null
                                                      ? 'Score : ' +
                                                          userObj.score
                                                              .toString()
                                                      : '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: (snapshot.data.blog != null &&
                                      snapshot.data.blog.toString().length > 2),
                                  child: _infoRow(
                                      snapshot.data.blog, '', 'info80'),
                                ),
                                Visibility(
                                  visible: snapshot.data.email != null,
                                  child: _infoRow(
                                      snapshot.data.email, '', 'email96'),
                                ),
                                _infoRow(_dateFormat(snapshot.data.created_at),
                                    'Joined At : ', 'create80'),
                                _infoRow(_dateFormat(snapshot.data.updated_at),
                                    'Last Updated At : ', 'clock80'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _getCard(userObj, snapshot, snapshot.data.followers,
                                'Followers', 'adduser80'),
                            _getCard(userObj, snapshot, snapshot.data.following,
                                'Following', 'checkeduser80'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _getCard(
                                userObj,
                                snapshot,
                                snapshot.data.public_gists,
                                'Public Gists',
                                'code80'),
                            _getCard(
                                userObj,
                                snapshot,
                                snapshot.data.public_repos,
                                'Repository',
                                'repository80'),
                          ],
                        ),
                      ],
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

  Widget _infoRow(data, title, imgName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image(
          image: AssetImage('assets/images/' + imgName + '.png'),
          width: 20,
          height: 20,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              data != null ? title + data : '',
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getCard(userObj, snapshot, aCount, name, imgName) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (snapshot.data.followers > 0) {
            switch (name) {
              case 'Followers':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FollowersPage(username: userObj.login)));
                break;
              case 'Following':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FollowingPage(username: userObj.login)));
                break;
              case 'Repository':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RepositoryPage(username: userObj.login)));
                break;
              case 'Public Gists':
                break;
            }
          } else {
            _showSnackMsg(name);
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  aCount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
                Container(padding: const EdgeInsets.all(6.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image:
                          AssetImage('assets/images/' + imgName + '.png'),
                      width: 25,
                      height: 25,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                    Text(
                      ' ' + name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  Future<UserDetailsResponse?> _getUserDetails(username) async {
    try {
      UserDetailsResponse userDetail;
      var response = await http.get(Uri.parse(constants.BaseURL + 'users/' + username));
      var aObj = json.decode(response.body);
      userDetail = UserDetailsResponse(
        aObj["name"],
        aObj["login"],
        aObj["avatar_url"],
        aObj["bio"],
        aObj["location"],
        aObj["html_url"],
        aObj["blog"],
        aObj["email"],
        aObj["public_repos"],
        aObj["public_gists"],
        aObj["followers"],
        aObj["following"],
        aObj["created_at"],
        aObj["updated_at"],
      );
      return userDetail;
    } on SocketException catch (_) {
      // print('not connected');
      final snackBar = SnackBar(
        content: const Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getUserDetails(username);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showSnackMsg(String s) {
    final snackBar = SnackBar(
      content: Text(s + ' not Found !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _dateFormat(String s) {
    var parsedDate = DateTime.parse(s);
    var formatter = DateFormat('dd MMM yyyy @ HH:mm');
    s = formatter.format(parsedDate);
    return s;
  }
}
