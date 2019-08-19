import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import '../model/item.dart';
import '../model/user_detail_response.dart';
import '../utility/utility.dart';
import './userdetail.dart';
import '../constant.dart' as Constants;

import './followers.dart';
import './following.dart';
import './repositories.dart';

class UserDetailPage extends StatelessWidget {
  final Item user;

  UserDetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: this.user.login, userObj: this.user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.userObj}) : super(key: key);

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
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
                                                snapshot.data.name != null
                                                    ? snapshot.data.name
                                                    : '',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 22),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  snapshot.data.bio != null,
                                              child: Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible:
                                                  snapshot.data.bio != null,
                                              child: Text(
                                                  snapshot.data.bio != null
                                                      ? snapshot.data.bio
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                            Visibility(
                                              visible: snapshot.data.location !=
                                                  null,
                                              child: Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible: snapshot.data.location !=
                                                  null,
                                              child: Text(
                                                  snapshot.data.location != null
                                                      ? snapshot.data.location
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                            Visibility(
                                              visible: userObj.score != null,
                                              child: Text('',
                                                  style:
                                                      TextStyle(fontSize: 4)),
                                            ),
                                            Visibility(
                                              visible: snapshot.data.location !=
                                                  null,
                                              child: Text(
                                                  userObj.score != null
                                                      ? 'Score : ' +
                                                          userObj.score
                                                              .toString()
                                                      : '',
                                                  style: TextStyle(
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            "assets/images/info80.png"),
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
                                            snapshot.data.blog != null
                                                ? snapshot.data.blog
                                                : '',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: snapshot.data.email != null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            "assets/images/email96.png"),
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
                                            snapshot.data.email != null
                                                ? snapshot.data.email
                                                : '',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      image: new AssetImage(
                                          "assets/images/create80.png"),
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
                                          'Joined At : ' +
                                              _dateFormat(
                                                  snapshot.data.created_at),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      image: new AssetImage(
                                          "assets/images/clock80.png"),
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
                                          'Last Updated At : ' +
                                              _dateFormat(snapshot.data.updated_at),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (snapshot.data.followers > 0) {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                FollowersPage(userObj.login)));
                                  } else {
                                    _showSnackMsg('Followers');
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.followers.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        Container(padding: EdgeInsets.all(6.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image(
                                              image: new AssetImage(
                                                  "assets/images/adduser80.png"),
                                              width: 25,
                                              height: 25,
                                              color: null,
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                            ),
                                            Text(
                                              ' Followers',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (snapshot.data.following > 0) {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                FollowingPage(userObj.login)));
                                  } else {
                                    _showSnackMsg('Following');
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.following.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        Container(padding: EdgeInsets.all(6.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image(
                                              image: new AssetImage(
                                                  "assets/images/checkeduser80.png"),
                                              width: 25,
                                              height: 25,
                                              color: null,
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                            ),
                                            Text(
                                              ' Following',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.public_gists.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      ),
                                      Container(padding: EdgeInsets.all(6.0)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "assets/images/code80.png"),
                                            width: 25,
                                            height: 25,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          ),
                                          Text(
                                            ' Public Gists',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (snapshot.data.public_repos > 0) {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                RepositoryPage(userObj.login)));
                                  } else {
                                    _showSnackMsg('Repository');
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.public_repos.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        Container(padding: EdgeInsets.all(6.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image(
                                              image: new AssetImage(
                                                  "assets/images/repository80.png"),
                                              width: 25,
                                              height: 25,
                                              color: null,
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                            ),
                                            Text(
                                              ' Repositories',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
  Future<UserDetailsResponse> _getUserDetails(username) async {
    try {
      UserDetailsResponse userDetail;
      var response = await http.get(Constants.BaseURL + 'users/' + username);
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
      print('not connected');
      final snackBar = SnackBar(
        content: Text('No Internet connected!'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _getUserDetails(username);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _showSnackMsg(String s) {
    final snackBar = SnackBar(
      content: Text(s + ' not Found !'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String _dateFormat(String s) {
    var parsedDate = DateTime.parse(s);
    var formatter = new DateFormat('dd MMM yyyy @ HH:mm');
    s = formatter.format(parsedDate);
    return s;
  }
}
