import 'package:Solon/app_localizations.dart';
import 'package:Solon/auth/button.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:Solon/api/api_connect.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _email, _password;
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
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  AppLocalizations.of(context).translate('email'),
                  textScaleFactor: 1.5,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your email';
                    }
                    return null;
                  },
                  onSaved: (input) => _email = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context).translate('password'),
                  textScaleFactor: 1.5,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your password';
                    }
                    return null;
                  },
                  onSaved: (input) => _password = input,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: _toggle,
                  )),
                ),
              ),
              Button(
                function: signIn,
                margin: const EdgeInsets.only(top: 25),
                label: "Sign In", // AppLocalizations.of(context).translate('signin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print('$_email $_password');
      final responseMessage = await APIConnect.loginUser(_email, _password);
      if (responseMessage["message"] == "Error") {
        _showToast(responseMessage["error"]["errorMessage"]);
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(uid: responseMessage["uid"]),
          ),
        );
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
