import 'package:Solon/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Solon/navbar.dart';
import 'package:Solon/auth/welcome.dart';
import 'package:Solon/home_screen.dart';
import 'package:Solon/proposal/screen.dart';
import 'package:Solon/event/screen.dart';
import 'package:Solon/forum/screen.dart';
import 'package:Solon/account_screen.dart';
import 'package:Solon/api/api_connect.dart';

void main() => runApp(Solon());

class Solon extends StatefulWidget {
  Solon({Key key}) : super(key: key);

  @override
  _SolonState createState() => _SolonState();
}

class _SolonState extends State<Solon> {
  static const String _title = 'Home';
  final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // disable landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        canvasColor: Colors.white,
        primaryColor: Colors.pink[400],
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          brightness:
              Brightness.light, // TODO: have yet to find a nonjanky method
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
                : Main();
          },
        ),
      ),
      supportedLocales: i18n.supportedLocales,
      localizationsDelegates: [
        i18n,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate
      ],
      localeResolutionCallback:
          // i18n.resolution(fallback: Locale("en", "US"))
          (locale, supportedLocales) {
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
  Main({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> {
  var _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKey');

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
    String curTitle = _widgetOptions[_selectedIndex]['title'];
    String titleText;
    if (curTitle == 'home') {
      titleText = I18n.of(context).home;
    } else if (curTitle == 'proposals') {
      titleText = I18n.of(context).proposals;
    } else if (curTitle == 'events') {
      titleText = I18n.of(context).events;
    } else {
      titleText = I18n.of(context).forum;
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titleText),
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
                  builder: (context) => AccountScreen(),
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
