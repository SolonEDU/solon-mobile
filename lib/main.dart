import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter/services.dart';

import 'package:Solon/navbar.dart';
import 'package:Solon/auth/welcome.dart';
import 'package:Solon/home_screen.dart';
import 'package:Solon/proposal/screen.dart';
import 'package:Solon/event/screen.dart';
import 'package:Solon/forum/screen.dart';
import 'package:Solon/account_screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';
// import 'package:Solon/loader.dart';

void main() => runApp(Solon());

class Solon extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Colors.pink[400],
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
        cursorColor: Colors.pink[400],
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: APIConnect.connectSharedPreferences(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            return snapshot.data.containsKey('errorMessage')
                ? WelcomePage()
                : Main(uid: snapshot.data['uid']);
          },
        ),
      ),
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
        Locale('fr', 'FR'),
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
        Locale('es', 'MX'),
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
        if (locale == null) {
          debugPrint("*language locale is null!");
          return supportedLocales.first;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        print('${locale.languageCode} printed from main ${locale.countryCode}');

        return supportedLocales.first;
      },
    );
  }
}

class Main extends StatefulWidget {
  final int uid;
  Main({Key key, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> {
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _widgetOptions = [
      {
        'title': 'home',
        'widget': HomeScreen(uid: widget.uid),
      },
      {
        'title': 'proposals',
        'widget': ProposalsScreen(uid: widget.uid),
      },
      {
        'title': 'events',
        'widget': EventsScreen(uid: widget.uid),
      },
      {
        'title': 'forum',
        'widget': ForumScreen(uid: widget.uid),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)
              .translate(_widgetOptions[_selectedIndex]['title']),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            color: Colors.pinkAccent[400],
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(uid: widget.uid),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex]['widget'],
      ),
      bottomNavigationBar: NavBar(
        _selectedIndex,
        _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
