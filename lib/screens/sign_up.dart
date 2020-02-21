import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';
import 'package:Solon/services/user_connect.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';
import 'package:Solon/widgets/buttons/preventable_button.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/screens/sign_in.dart';

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
      key: _scaffoldKey,
      appBar: PageAppBar(
        title: AppLocalizations.of(context).translate("signUp"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20),
              child: Text(
                AppLocalizations.of(context).translate("language"),
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
                      value: value,
                      child: Text(nativeLangNames[value]),
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate("name"),
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
                        if (input.isEmpty || input.trim().isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("fNameSignUpFieldError");
                        }
                        return null;
                      },
                      onSaved: (input) => _firstName = input,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate("firstName")),
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
                        if (input.isEmpty || input.trim().isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("lNameSignUpFieldError");
                        }
                        return null;
                      },
                      onSaved: (input) => _lastName = input,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate("lastName")),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate("email"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (input) {
                  if (input.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("emailSignUpFieldError");
                  }
                  return null;
                },
                onSaved: (input) => _email = input,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                AppLocalizations.of(context).translate("password"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input.length < 6) {
                    return AppLocalizations.of(context)
                        .translate("passwordSignUpFieldError");
                  } else {
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
                AppLocalizations.of(context).translate("confirmPassword"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input != _password) {
                    return AppLocalizations.of(context)
                        .translate("confirmPasswordSignUpFieldName");
                  }
                  return null;
                },
                obscureText: true,
              ),
            ),
            PreventableButton(
              body: <Map>[
                {
                  "color": Colors.pink[200],
                  "height": 55.0,
                  "width": 155.0,
                  "function": signUp,
                  "margin": const EdgeInsets.only(top: 25, bottom: 10),
                  "label": AppLocalizations.of(context).translate("signUp"),
                }
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stream<bool> signUp() async* {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      yield true;
      formState.save();
      final responseMessage = await UserConnect.registerUser(
          _nativeLanguage, _firstName, _lastName, _email, _password);
      if (responseMessage["message"] == "Error") {
        UserUtil.showToast(responseMessage["error"]["errorMessage"], _scaffoldKey);
        yield false;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    } else {
      yield false;
    }
  }
}
