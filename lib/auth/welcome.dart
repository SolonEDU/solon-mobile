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
      // backgroundColor: Color(0xFFECE2D0),
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
              minWidth: 125,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20),
                ),
                onPressed: navigateToSignIn,
                color: Color(0xFF98D2EB),
                child: Text("Sign in"),
              ),
            ),
            ButtonTheme(
              minWidth: 125,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20),
                ),
                onPressed: navigateToSignUp,
                color: Color(0xFF98D2EB),
                child: Text("Sign up"),
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
