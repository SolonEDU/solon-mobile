import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';
import 'package:Solon/services/user_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';
import 'package:Solon/main.dart';
import 'package:Solon/widgets/buttons/button.dart';

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
      key: _scaffoldKey,
      appBar: PageAppBar(
        title: AppLocalizations.of(context).translate("signIn"),
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
                  AppLocalizations.of(context).translate("email"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("emailSignInFieldError");
                    }
                    return null;
                  },
                  onSaved: (input) => _email = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context).translate("password"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("passwordSignInFieldError");
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
                color: Colors.pink[200],
                height: 55.0,
                function: signIn,
                margin: const EdgeInsets.only(top: 25, bottom: 25),
                label: AppLocalizations.of(context).translate("signIn"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      final responseMessage = await UserConnect.loginUser(_email, _password);
      if (responseMessage["message"] == "Error") {
        String message;
        if (responseMessage["error"]["errorMessage"] == "Incorrect password") {
          message = AppLocalizations.of(context).translate("incorrectPassword");
        } else {
          message = AppLocalizations.of(context).translate(
              "userDoesNotExist"); // TODO: need a better way to code for this logic; be wary of this line when we add in more errors to sign in
        }
        UserUtil.showToast(message, _scaffoldKey);
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(),
          ),
        );
      }
    }
  }
}
