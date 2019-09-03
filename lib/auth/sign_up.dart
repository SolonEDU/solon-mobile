import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Solon/auth/sign_in.dart';
import 'package:Solon/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name, _email, _password;
  String _nativeLanguage = 'English';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField(
                value: _nativeLanguage,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your native language';
                  }
                  return null;
                },
                onSaved: (input) => _nativeLanguage = input,
                onChanged: (input) {
                  setState(() {
                    _nativeLanguage = input;
                  });
                },
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('language')),
                items: <String>[
                  'English',
                  'Chinese (Simplified)',
                  'Chinese (Traditional)',
                  'Bengali'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (input) => _name = input,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('fullName')),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('email')),
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Your password needs to be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('password')),
                obscureText: true,
              ),
              RaisedButton(
                onPressed: signUp,
                child: Text(AppLocalizations.of(context).translate('signup')),
              )
            ],
          )),
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        // add user to firestore as a parent
        Firestore.instance.collection('users').document(user.uid).setData(
          {
            'email': user.email,
            'name': _name,
            'role': 'parent',
            'nativeLanguage': _nativeLanguage,
          },
        );
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print(e.message);
      }
    }
  }
}
