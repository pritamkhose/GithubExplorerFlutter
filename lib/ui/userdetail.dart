import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/item.dart';

class UserDetailPage extends StatelessWidget {
  final Item user;

  UserDetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.user.login),
      ),
      body: Container(
//        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  /*child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                backgroundImage: NetworkImage(user.avatar_url.toString()),
                maxRadius: 120.0,
              ),*/
                  child: Image(image: NetworkImage(user.avatar_url.toString())),
                ),
              ),
              Divider(),
              Flexible(
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  children: <String>[
                    user.avatar_url.toString(),
                    user.avatar_url.toString(),
                    user.avatar_url.toString(),
                    user.avatar_url.toString(),
                  ].map((String url) {
                    return new GridTile(
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            /*child: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            backgroundImage: NetworkImage(user.avatar_url.toString()),
                            maxRadius: 120.0,
                           ),*/
                            child: Image.network(url, fit: BoxFit.cover)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                // height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black),
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text('Full Name', textAlign: TextAlign.start),
                              new Text(user.login.toString(),
                                  textAlign: TextAlign.end),
                            ],
                          ),
                        )
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text('Score', textAlign: TextAlign.start),
                              new Text(user.score.toString(),
                                  textAlign: TextAlign.end),
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
//      ),
    );
  }
}
