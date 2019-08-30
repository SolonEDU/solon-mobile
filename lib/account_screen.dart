// import 'package:Solon/admin/proposal/proposal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import './parent/proposal/proposals_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({this.user});
  final FirebaseUser user;
  @override
  _AccountScreenState createState() => _AccountScreenState(user: user);
}

class _AccountScreenState extends State<AccountScreen> {
  _AccountScreenState({this.user});
  final FirebaseUser user;
  final db = Firestore.instance;
  String _languageCodeValue = 'English';

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-Hant',
    'Bengali': 'bn',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text('Name'),
            Text('Email'),
            Text('Current Language'),
            DropdownButton<String>(
              value: _languageCodeValue,
              onChanged: (String newValue) async {
                db
                    .collection('users')
                    .document(user.uid)
                    .updateData({'nativeLanguage': newValue});
                setState(() {
                  _languageCodeValue = newValue;
                });
              },
              items: <String>[
                'English',
                'Chinese (Simplified)',
                'Chinese (Traditional)',
                'Bengali',
                'Korean',
                'Russian',
                'Japanese',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
        ));
  }
}
