import 'package:flutter/material.dart';
import 'package:solon/auth/sign_in.dart';
import 'package:solon/auth/sign_up.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/solon.png'),
                ),
              ),
            );
          },
        ),
        title: Text('Solon'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            onPressed: navigateToSignIn,
            child: Text('Sign In'),
          ),
          RaisedButton(
            onPressed: navigateToSignUp,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
        fullscreenDialog: true,
      ),
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
