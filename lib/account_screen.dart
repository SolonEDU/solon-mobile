// import 'package:Solon/admin/proposal/proposal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_localizations.dart';

import './loader.dart';
// import './parent/proposal/proposals_screen.dart';

class AccountScreen extends StatefulWidget {
  final FirebaseUser user;
  const AccountScreen({this.user});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final db = Firestore.instance;
  var document;
  var _language; 

  void _update() {
    setState(() {
      document = db.collection('users').document(widget.user.uid);
    });
  }

  void _setLanguage(newValue) {
    setState(() {
      _language = newValue;
    });
  }

  @override
  initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: document.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('account')),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text(snapshot.data.data['name']),
                    Text(snapshot.data.data['email']),
                    DropdownButton<String>(
                      value: snapshot.data.data['nativeLanguage'],
                      onChanged: (String newValue) {
                        db
                            .collection('users')
                            .document(widget.user.uid)
                            .updateData({'nativeLanguage': newValue});
                        _setLanguage(newValue);
                        print(_language); //printing language to prevent blue error from popping up 
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
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
