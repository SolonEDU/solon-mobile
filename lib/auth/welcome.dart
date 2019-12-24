import 'package:Solon/auth/button.dart';
import 'package:flutter/material.dart';
import 'package:Solon/auth/sign_in.dart';
import 'package:Solon/auth/sign_up.dart';
// import 'package:Solon/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    var logoAsset = new AssetImage('images/solon.png');
    var logo = new Image(
      image: logoAsset,
      fit: BoxFit.fitHeight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: logo,
                height: 200,
                margin: const EdgeInsets.only(bottom: 40),
              ),
              Button(
                function: navigateToSignIn,
                label: "Sign In", // AppLocalizations.of(context).translate('signin'),
                margin: const EdgeInsets.all(0),
              ),
              Button(
                function: navigateToSignUp,
                label: "Register", // AppLocalizations.of(context).translate('signup')
                margin: const EdgeInsets.only(top: 20, bottom: 5),
              ),
            ],
          ),
        ),
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
