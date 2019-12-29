// import 'package:Solon/admin/proposal/proposal.dart';
// import 'package:Solon/auth/welcome.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'app_localizations.dart';
// import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/api/user.dart';
// import 'package:Solon/api/proposal.dart';

import 'package:Solon/loader.dart';
import 'main.dart';
// import './parent/proposal/proposals_screen.dart';
// import 'package:Solon/api/user.dart';
import 'package:Solon/api/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  final int uid;
  const AccountScreen({this.uid});
  // final FirebaseUser user;
  // const AccountScreen({this.user});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController streamController = StreamController();
  // final db = Firestore.instance;
  var document;
  var _language;

  // void _update() {
  //   setState(() {
  // document = db.collection('users').document(widget.user.uid);
  //   });
  // }

  // void _setLanguage(newValue) {
  //   setState(() {
  //     _language = newValue;
  //   });
  // }

  @override
  void initState() {
    load();
    super.initState();

    // _futureAttendanceVal =
    //     APIConnect.getAttendance(eid: widget.eid, uid: widget.uid);
    // print(_futureAttendanceVal.toString());
  }

  void load() async {
    streamController.add(await APIConnect.connectSharedPreferences());
    // await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  // @override
  // initState() {
  //   super.initState();
  //   print(widget.uid);
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(

    // );
    // return Scaffold(
    //   body: FutureBuilder<List<Proposal>>(
    //     future: APIConnect.connectProposals(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         List<Widget> users = [];
    //         for (var i = 0; i < snapshot.data.length; i++) {
    //           users.add(Text("${snapshot.data}"));
    //         }
    //         return ListView(
    //           children: users,
    //         );
    //       }
    //       return Loader();
    //     },
    //   ),
    // );
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // print('HELLO ${snapshot.data.firstName.toString()}');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          default:
            print(snapshot.data['lang']);
            _language = snapshot.data['lang'];
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context).translate('account'),
                ),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                        "Welcome ${snapshot.data['firstname']} ${snapshot.data['lastname']}!"),
                    Text("Email: ${snapshot.data['email']}"),
                    DropdownButton<String>(
                      value: _language,
                      onChanged: (String newValue) async {
                        // _setLanguage(newValue);
                        Map<String, dynamic> newMap = snapshot.data;
                        newMap['lang'] = newValue;
                        streamController.sink.add(newMap);
                        print(newValue);
                        final prefs = await SharedPreferences.getInstance();
                        final userData = prefs.getString('userData');
                        final userDataJson = json.decode(userData);
                        userDataJson['lang'] = newValue;
                        prefs.setString('userData', json.encode(userDataJson));
                        print(json.encode(userDataJson));
                        Message responseMessage =
                            await APIConnect.changeLanguage(
                                uid: snapshot.data['uid'],
                                updatedLang: json.decode(prefs.getString('userData'))['lang']);
                        _showToast(responseMessage.message == 'Error'
                            ? 'Language could not be changed to $newValue'
                            : "Language was successfully changed to $newValue");
                        // db
                        //     .collection('users')
                        //     .document(widget.user.uid)
                        //     .updateData({'nativeLanguage': newValue});
                        // _setLanguage(newValue);
                        print(
                            _language); //printing language to prevent blue error from popping up
                      },
                      items: <String>[
                        'English',
                        'Chinese (Simplified)',
                        'Chinese (Traditional)',
                        'Bengali',
                        'Korean',
                        'Russian',
                        'Japanese',
                        'Ukrainian'
                      ].map<DropdownMenuItem<String>>((String value) {
                        print(snapshot.data['lang']);
                        print(value);
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // RaisedButton(
                    //   onPressed: () async {
                    //     _showToast(
                    //         "Instructions to change your password were sent to your email address");
                    //     return FirebaseAuth.instance.sendPasswordResetEmail(
                    //         email: snapshot.data.data['email']);
                    //   },
                    //   child: Text("Change Password"),
                    // ),
                    RaisedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userData = prefs.clear();
                        // await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return MyApp();
                            }, transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) {
                              return new SlideTransition(
                                position: new Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            }),
                            (Route route) => false);
                      },
                      child: Text("Log Out"),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  void _showToast(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
