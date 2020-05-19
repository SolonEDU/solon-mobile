import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/util/app_localizations.dart';

class SortDropdownMenu extends StatelessWidget {
  final StreamController streamController;
  final String value;
  final String preferences;
  final List<DropdownMenuItem<String>> items;

  SortDropdownMenu({
    this.streamController,
    this.value,
    this.preferences,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate("sortBy"),
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
          ),
        ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
                value: value,
                iconSize: 24,
                elevation: 8,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.pink[400],
                ),
                onChanged: (String newValue) async {
                  streamController.sink.add(newValue);
                  final sharedPrefs = await SharedPreferences.getInstance();
                  sharedPrefs.setString(
                    preferences,
                    newValue,
                  );
                },
                items: items),
          ),
        ),
      ],
    );
  }
}
