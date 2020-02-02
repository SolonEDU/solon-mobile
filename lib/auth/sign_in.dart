import 'package:flutter/material.dart';

import 'package:Solon/main.dart';
import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/auth/button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Screen {
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
      key: _scaffoldKey,
      appBar: getPageAppBar(
        context,
        title: AppLocalizations.of(context).translate('signin'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  AppLocalizations.of(context).translate('email'),
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
                height: 55,
                width: 155,
                function: signIn,
                margin: const EdgeInsets.only(top: 25, bottom: 25),
                label: AppLocalizations.of(context).translate('signin'),
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
      final responseMessage = await APIConnect.loginUser(_email, _password);
      if (responseMessage["message"] == "Error") {
        showToast(responseMessage["error"]["errorMessage"], _scaffoldKey);
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
}
