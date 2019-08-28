import 'package:Solon/admin/proposal/proposal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './parent/proposal/proposals_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
        title: Text('Account Settings'),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: _languageCodeValue,
          onChanged: (String newValue) async {
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
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
      ),
    );
  }
}
