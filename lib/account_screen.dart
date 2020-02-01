// import 'package:Solon/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

// import 'package:Solon/loader.dart';
import 'package:Solon/main.dart';
import 'package:Solon/screen.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/api/message.dart';

class AccountScreen extends StatefulWidget {
  final int uid;
  const AccountScreen({this.uid});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with Screen {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController streamController = StreamController.broadcast();
  var document;
  var _language;
  int _userUid;

  @override
  void initState() {
    load();
    super.initState();
  }

  Future<Null> load() async {
    streamController.add(await APIConnect.connectSharedPreferences());
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUid = json.decode(prefs.getString('userData'))['uid'];
    });
  }

  Future<Null> _refresh() async {
    final dbUserData = await APIConnect.connectUser(uid: _userUid);
    streamController.add(dbUserData);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            _language = snapshot.data['lang'];
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: getPageAppBar(
                  context,
                  AppLocalizations.of(context).translate('account'),
                ),
                body: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                          "Welcome ${snapshot.data['firstname']} ${snapshot.data['lastname']}!"),
                      Text("Email: ${snapshot.data['email']}"),
                      DropdownButton<String>(
                        value: _language,
                        onChanged: (String newValue) async {
                          // _setLanguage(newValue);
                          Map<String, dynamic> newMap = snapshot.data;
                          newMap['lang'] = newValue;
                          streamController.sink.add(newMap);
                          // print(newValue);
                          final prefs = await SharedPreferences.getInstance();
                          final userData = prefs.getString('userData');
                          final userDataJson = json.decode(userData);
                          userDataJson['lang'] = newValue;
                          prefs.setString(
                              'userData', json.encode(userDataJson));
                          // print(json.encode(userDataJson));
                          Message responseMessage =
                              await APIConnect.changeLanguage(
                                  uid: snapshot.data['uid'],
                                  updatedLang: json.decode(
                                      prefs.getString('userData'))['lang']);
                          showToast(
                              responseMessage.message == 'Error'
                                  ? 'Language could not be changed to $newValue'
                                  : "Language was successfully changed to $newValue",
                              _scaffoldKey);
                        },
                        items: <String>[
                          'English',
                          'Chinese (Simplified)',
                          'Chinese (Traditional)',
                          'Bengali',
                          'Korean',
                          'Russian',
                          'Japanese',
                          'Ukrainian'
                        ].map<DropdownMenuItem<String>>((String value) {
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
                            value: nativeLangNames[value],
                            child: Text(nativeLangNames[value]),
                          );
                        }).toList(),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(pageBuilder:
                                  (BuildContext context, Animation animation,
                                      Animation secondaryAnimation) {
                                return Solon();
                              }, transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                return new SlideTransition(
                                  position: new Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              }),
                              (Route route) => false);
                        },
                        child: Text("Log Out"),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
