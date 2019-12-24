// import 'dart:convert';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/auth/button.dart';
import 'package:Solon/auth/sign_in.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _firstName, _lastName, _email, _password;
  String _nativeLanguage = 'English';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
          onPressed: () => {
            FocusScope.of(context).unfocus(),
            Navigator.pop(context),
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20),
              child: Text(
                AppLocalizations.of(context).translate('language'),
                textScaleFactor: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: DropdownButtonFormField(
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
                items: <String>[
                  'English',
                  'Chinese (Simplified)',
                  'Chinese (Traditional)',
                  'Bengali',
                  'Korean',
                  'Russian',
                  'Japanese',
                  'Ukrainian',
                ].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "First Name",
                textScaleFactor: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (input) => _firstName = input,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Last Name",
                textScaleFactor: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (input) => _lastName = input,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate('email'),
                textScaleFactor: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onSaved: (input) => _email = input,
              ),
            ),
            // TextFormField(
            //   validator: (input) {
            //     if (input.isEmpty) {
            //       return 'Please enter the authentication pin provided to you by email';
            //     }
            //     return null;
            //   },
            //   onSaved: (input) => _authpin = input,
            //   decoration: InputDecoration(labelText: 'Authentication Pin')
            // ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate('password'),
                textScaleFactor: 1.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input.length < 6) {
                    return 'Your password needs to be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
            ),
            Button(
              function: signUp,
              margin: const EdgeInsets.only(top: 25, bottom: 10),
              label:
                  "Sign Up", // AppLocalizations.of(context).translate('signup')
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      // print(_password);
      final responseMessage = await APIConnect.registerUser(
          _nativeLanguage, _firstName, _lastName, _email, _password);
      print(responseMessage["message"]);
      if (responseMessage["message"] == "Error") {
        _showToast(responseMessage["error"]["errorMessage"]);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  void _showToast(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
