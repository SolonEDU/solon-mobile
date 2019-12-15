// import 'package:Solon/admin/proposal/proposal.dart';
// import 'package:Solon/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'app_localizations.dart';
import 'package:Solon/API/api_connect.dart';
import 'package:Solon/API/user.dart';


import './loader.dart';
// import 'main.dart';
// import './parent/proposal/proposals_screen.dart';

class AccountScreen extends StatefulWidget {
  final FirebaseUser user;
  const AccountScreen({this.user});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Firestore.instance;
  var document;
  // var _language;

  void _update() {
    setState(() {
      document = db.collection('users').document(widget.user.uid);
    });
  }

  // void _setLanguage(newValue) {
  //   setState(() {
  //     _language = newValue;
  //   });
  // }

  @override
  initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
          future: APIConnect.connectUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> users = [];
              for(var i = 0; i < snapshot.data.length; i++) {
                users.add(Text("uid: ${snapshot.data[i].uid}, first name: ${snapshot.data[i].firstName}, last name: ${snapshot.data[i].lastName}, email: ${snapshot.data[i].email}"));
              }
              return Scaffold(
                body: ListView(
                  children: users,
                ),
              );
            }
            return Loader();
          }
        );
    // return FutureBuilder(
    //   future: document.get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Scaffold(
    //           body: Center(
    //             child: Loader(),
    //           ),
    //         );
    //       default:
    //         return Scaffold(
    //           key: _scaffoldKey,
    //           appBar: AppBar(
    //             title: Text(AppLocalizations.of(context).translate('account')),
    //           ),
    //           body: Center(
    //             child: Column(
    //               children: <Widget>[
    //                 Text("Name: " + snapshot.data.data['name']),
    //                 Text("Email: " + snapshot.data.data['email']),
    //                 DropdownButton<String>(
    //                   value: snapshot.data.data['nativeLanguage'],
    //                   onChanged: (String newValue) {
    //                     db
    //                         .collection('users')
    //                         .document(widget.user.uid)
    //                         .updateData({'nativeLanguage': newValue});
    //                     _setLanguage(newValue);
    //                     print(_language); //printing language to prevent blue error from popping up
    //                   },
    //                   items: <String>[
    //                     'English',
    //                     'Chinese (Simplified)',
    //                     'Chinese (Traditional)',
    //                     'Bengali',
    //                     'Korean',
    //                     'Russian',
    //                     'Japanese',
    //                     'Ukrainian'
    //                   ].map<DropdownMenuItem<String>>((String value) {
    //                     return DropdownMenuItem<String>(
    //                       value: value,
    //                       child: Text(value),
    //                     );
    //                   }).toList(),
    //                 ),
    //                 RaisedButton(
    //                   onPressed: () async {
    //                     _showToast("Instructions to change your password were sent to your email address");
    //                     return FirebaseAuth.instance.sendPasswordResetEmail(email: snapshot.data.data['email']);
    //                   },
    //                   child: Text("Change Password"),
    //                 ),
    //                 RaisedButton(
    //                   onPressed: () async {
    //                     await FirebaseAuth.instance.signOut();
    //                     Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new MyApp()));
    //                   },
    //                   child: Text("Log Out"),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //     }
    //   },
    // );
  }

  // void _showToast(String message) {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }
}
