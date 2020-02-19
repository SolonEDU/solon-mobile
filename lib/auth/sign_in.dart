import 'package:Solon/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:Solon/main.dart';
import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
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
        title: I18n.of(context).signIn,
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
                  I18n.of(context).email,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input.isEmpty) {
                      return I18n.of(context).emailSignInFieldError;
                    }
                    return null;
                  },
                  onSaved: (input) => _email = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  I18n.of(context).password,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return I18n.of(context).passwordSignInFieldError;
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
                height: 55,
                width: 155,
                function: signIn,
                margin: const EdgeInsets.only(top: 25, bottom: 25),
                label: I18n.of(context).signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      final responseMessage = await APIConnect.loginUser(_email, _password);
      if (responseMessage["message"] == "Error") {
        String message = responseMessage["error"]["errorMessage"] == "Incorrect password" ? I18n.of(context).incorrectPassword : I18n.of(context).userDoesNotExist(_email); // TODO: need a better to code for this logic; be wary of this line when we add in more errors to sign in
        showToast(message, _scaffoldKey);
        return false;
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(),
          ),
        );
      }
    } else {
      return false;
    }
  }
}
