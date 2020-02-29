import 'dart:async';
import 'dart:convert';

import 'package:Solon/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/services/user_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/user_util.dart';
import 'package:Solon/models/message.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';
import 'package:Solon/widgets/buttons/button.dart';
import 'package:Solon/main.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen();

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController<Map<String, dynamic>> streamController =
      StreamController.broadcast();
  var _language;
  int _userUid;

  @override
  void initState() {
    load();
    super.initState();
  }

  Future<Null> load() async {
    final sharedPrefs =
        await UserUtil.connectSharedPreferences(key: 'userData');
    streamController.add(sharedPrefs);
    setState(() {
      _userUid = sharedPrefs['uid'];
    });
    final apiUserData = await UserConnect.connectUser(uid: _userUid);
    final userPrefLang = apiUserData['lang'];
    print(userPrefLang);
  }

  Future<Null> _refresh() async {
    final sharedPrefsUserData = await UserConnect.connectUser(uid: _userUid);
    streamController.add(sharedPrefsUserData);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: streamController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ErrorScreen(error: snapshot.error);
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError) return ErrorScreen(error: snapshot.error);
            _language = snapshot.data['lang'];
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: PageAppBar(
                  title: AppLocalizations.of(context).translate("account"),
                ),
                body: Container(
                  margin: const EdgeInsets.all(20),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate("name"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 25,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Text(
                              '${snapshot.data['firstname']} ${snapshot.data['lastname']}',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).translate("email"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 25,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Text(
                              "${snapshot.data['email']}",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).translate("language"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                                fontSize: 25),
                          ),
                          DropdownButton<String>(
                            value: _language,
                            isExpanded: true,
                            onChanged: (String newValue) async {
                              Map<String, dynamic> newMap = snapshot.data;
                              newMap['lang'] = newValue;
                              streamController.sink.add(newMap);
                              final sharedPrefs =
                                  await SharedPreferences.getInstance();
                              final userDataJson =
                                  await UserUtil.connectSharedPreferences(
                                      key: 'userData');
                              userDataJson['lang'] = newValue;
                              sharedPrefs.setString(
                                'userData',
                                json.encode(userDataJson),
                              );
                              Message responseMessage =
                                  await UserConnect.changeLanguage(
                                uid: snapshot.data['uid'],
                                updatedLang: userDataJson['lang'],
                              );
                              UserUtil.showToast(
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
                            ].map<DropdownMenuItem<String>>(
                              (String value) {
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
                                  value: value,
                                  child: Text(nativeLangNames[value]),
                                );
                              },
                            ).toList(),
                          ),
                          Center(
                            child: Button(
                              color: Colors.pink[200],
                              height: 55,
                              label: AppLocalizations.of(context)
                                  .translate("signOut"),
                              margin: EdgeInsets.only(top: 10),
                              function: () async {
                                final sharedPrefs =
                                    await SharedPreferences.getInstance();
                                sharedPrefs.clear();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                      BuildContext context,
                                      Animation animation,
                                      Animation secondaryAnimation,
                                    ) {
                                      return Solon();
                                    },
                                    transitionsBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child,
                                    ) {
                                      return new SlideTransition(
                                        position: new Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                  (Route route) => false,
                                );
                              },
                            ),
                          ),
                        ],
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
