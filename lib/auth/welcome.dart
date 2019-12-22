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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: logo,
              height: 200,
              margin: const EdgeInsets.only(bottom: 40),
            ),
            ButtonTheme(
              minWidth: 155,
              height: 55,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30),
                ),
                onPressed: navigateToSignIn,
                color: Color(0xFF98D2EB),
                child: Text(
                  "Sign In",
                  textScaleFactor: 1.5,
                ), // AppLocalizations.of(context).translate('signin'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ButtonTheme(
                minWidth: 155,
                height: 55,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30),
                  ),
                  onPressed: navigateToSignUp,
                  color: Color(0xFF98D2EB),
                  child: Text(
                    "Register",
                    textScaleFactor: 1.5,
                  ), // AppLocalizations.of(context).translate('signup')
                ),
              ),
            ),
          ],
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
