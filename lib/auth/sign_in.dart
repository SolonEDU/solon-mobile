import 'package:Solon/app_localizations.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:Solon/api/api_connect.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var logoAsset = new AssetImage('images/solon.png');
    var logo = new Image(
      image: logoAsset,
      fit: BoxFit.fitHeight,
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: logo,
                    height: 150,
                  ),
                  TextFormField(
                    // key: _formKey,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type an email';
                      }
                      return null;
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('email')),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type a password';
                      }
                      return null;
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('password')),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Align(
                child: SizedBox(
                  height: 55,
                  width: 155,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                    color: Color(0xFF98D2EB),
                    onPressed: signIn,
                    child: Text(
                      "Sign In",
                      textScaleFactor: 1.5,
                    ), // AppLocalizations.of(context).translate('signin'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print('${_email} ${_password}');
      final responseMessage = await APIConnect.loginUser(_email, _password);
      print(responseMessage["message"]);
      if (responseMessage["message"] == "Error") {
        _showToast(responseMessage["error"]["errorMessage"]);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(uid: responseMessage["uid"]),
          ),
        );
      }
      //   try {
      //     AuthResult result = await FirebaseAuth.instance
      //         .signInWithEmailAndPassword(email: _email, password: _password);
      //     FirebaseUser user = result.user;
      //     if (!user.isEmailVerified) {
      //       _showToast('Email is not verified');
      //     } else {
      //       Firestore.instance
      //           .collection('users')
      //           .document(user.uid)
      //           .get()
      //           .then((DocumentSnapshot ds) {
      //       });
      //     }
      //   } catch (e) {
      //     _showToast(e.message);
      //   }
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
