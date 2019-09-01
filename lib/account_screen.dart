// import 'package:Solon/admin/proposal/proposal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loader.dart';
// import './parent/proposal/proposals_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseUser user;
  _AccountScreenState();
  final db = Firestore.instance;
  var document;
  var _language;

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-Hant',
    'Bengali': 'bn',
  };

  void _update() {
    setState(() {
      document = db.collection('users').document(user.uid);
    });
  }

  void _getUser() {
    FirebaseAuth.instance.currentUser().then((future) {
      user = future;
      _update();
    });
  }

  void _setLanguage(newValue) {
    setState(() {
      _language = newValue;
    });
  }

  @override
  initState() {
    _getUser();
    super.initState();
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
                title: Text('Account'),
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
                            .document(user.uid)
                            .updateData({'nativeLanguage': newValue});
                        _setLanguage(newValue);
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
