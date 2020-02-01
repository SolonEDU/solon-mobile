import 'package:flutter/material.dart';

import 'package:Solon/auth/button.dart';
import 'package:Solon/auth/sign_in.dart';
import 'package:Solon/auth/sign_up.dart';
import 'package:Solon/app_localizations.dart';

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
                height: 55,
                width: 155,
                function: navigateToSignIn,
                label: AppLocalizations.of(context).translate('signin'),
                margin: const EdgeInsets.all(0),
              ),
              Button(
                height: 55,
                width: 155,
                function: navigateToSignUp,
                label: AppLocalizations.of(context).translate('signup'),
                margin: const EdgeInsets.only(top: 20, bottom: 20),
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
