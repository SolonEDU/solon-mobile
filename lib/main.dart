import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
// import 'package:flutter/services.dart';

import './navbar.dart';
import 'package:Solon/auth/welcome.dart';
import 'package:Solon/parent/home_screen.dart';
import './parent/proposal/proposals_screen.dart';
import './parent/event/screen.dart';
import './parent/forum/screen.dart';
import './account_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   //DeviceOrientation.portraitUp,
    // ]);
    return MaterialApp(
      title: _title,
      home: WelcomePage(),
      supportedLocales: [
        Locale('en'),
        Locale('af'),
        Locale('sq'),
        Locale('ar'),
        Locale('az'),
        Locale('eu'),
        Locale('bn'),
        Locale('be'),
        Locale('bg'),
        Locale('ca'),
        Locale('chr'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
        Locale('hr'),
        Locale('cs'),
        Locale('da'),
        Locale('nl'),
        Locale('en', 'GB'),
        Locale('eo'),
        Locale('et'),
        Locale('tl'),
        Locale('fi'),
        Locale('fr'),
        Locale('gl'),
        Locale('ka'),
        Locale('de'),
        Locale('el'),
        Locale('gu'),
        Locale('ht'),
        Locale('iw'),
        Locale('hi'),
        Locale('hu'),
        Locale('is'),
        Locale('id'),
        Locale('ga'),
        Locale('it'),
        Locale('ja'),
        Locale('kn'),
        Locale('ko'),
        Locale('la'),
        Locale('lv'),
        Locale('lt'),
        Locale('mk'),
        Locale('ms'),
        Locale('mt'),
        Locale('no'),
        Locale('fa'),
        Locale('pl'),
        Locale('pt'),
        Locale('pt', 'PT'),
        Locale('ro'),
        Locale('ru'),
        Locale('sr'),
        Locale('sk'),
        Locale('sl'),
        Locale('es'),
        Locale('sw'),
        Locale('sv'),
        Locale('ta'),
        Locale('te'),
        Locale('th'),
        Locale('tr'),
        Locale('uk'),
        Locale('ur'),
        Locale('vi'),
        Locale('cy'),
        Locale('yi'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<Main> {
  final db = Firestore.instance;
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var _widgetOptions = [
    {
      'title': 'home',
      'widget': HomeScreen(),
    },
    {
      'title': 'proposals',
      'widget': ProposalsScreen(),
    },
    {
      'title': 'events',
      'widget': EventsScreen(),
    },
    {
      'title': 'forum',
      'widget': ForumScreen(),
    },
  ];

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
        title: Text(AppLocalizations.of(context).translate(_widgetOptions[_selectedIndex]['title'])),
        actions: <Widget>[
          FloatingActionButton(
            heroTag: 'unq0',
            elevation: 0.0,
            child: Icon(Icons.account_circle),
            onPressed: () async {
              FirebaseUser user = await FirebaseAuth.instance.currentUser();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(child: _widgetOptions[_selectedIndex]['widget']),
      bottomNavigationBar: NavBar(
        _selectedIndex,
        _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
