import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(AppLocalizations.of(context).translate('parentHomeScreen')),
    );
  }
}
