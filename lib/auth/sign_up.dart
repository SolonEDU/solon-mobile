import 'package:flutter/material.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/auth/button.dart';
import 'package:Solon/auth/sign_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with Screen {
  String _firstName, _lastName, _email, _password;
  String _nativeLanguage = 'English';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: getPageAppBar(
        context,
        AppLocalizations.of(context).translate('signup'),
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
                textScaleFactor: 1,
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
                    Map<String, String> nativeLangNames = {
                      'English': 'English',
                      'Chinese (Simplified)': '中文（简体）',
                      'Chinese (Traditional)': '中文（繁体）',
                      'Bengali': 'বাংলা',
                      'Korean': '한국어',
                      'Russian': 'Русский язык',
                      'Japanese': '日本語',
                      'Ukrainian': 'українська мова',
                    };
                    return DropdownMenuItem<String>(
                      value: nativeLangNames[value],
                      child: Text(nativeLangNames[value]),
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Name",
                textScaleFactor: 1,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 10, bottom: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onSaved: (input) => _firstName = input,
                      decoration: InputDecoration(labelText: 'First name'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 20, bottom: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (input) => _lastName = input,
                      decoration: InputDecoration(labelText: 'Last name'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate('email'),
                textScaleFactor: 1,
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
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate('password'),
                textScaleFactor: 1,
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
                  else {
                    _password = input;
                    return null;
                  }
                },
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'Confirm Password',
                // AppLocalizations.of(context).translate('password'),
                textScaleFactor: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input != _password) {
                    return 'Your passwords do not match';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ),
            Button(
              function: signUp,
              margin: const EdgeInsets.only(top: 25, bottom: 10),
              label: AppLocalizations.of(context).translate('signup'),
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
      final responseMessage = await APIConnect.registerUser(
          _nativeLanguage, _firstName, _lastName, _email, _password);
      print(responseMessage["message"]);
      if (responseMessage["message"] == "Error") {
        showToast(responseMessage["error"]["errorMessage"], _scaffoldKey);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }
}
