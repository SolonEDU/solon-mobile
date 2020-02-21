import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:Solon/screens/welcome.dart';
import 'package:Solon/screens/home_screen.dart';
import 'package:Solon/screens/proposal/screen.dart';
import 'package:Solon/screens/event/screen.dart';
import 'package:Solon/screens/forum/screen.dart';
import 'package:Solon/screens/account_screen.dart';
import 'package:Solon/widgets/nav_bar.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/util/app_localizations.dart';

void main() => runApp(Solon());

class Solon extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // disable landscape
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
      supportedLocales: [
        Locale("en", "US"),
        Locale("zh", "CN"),
        Locale("zh", "TW"),
        Locale("bn", "BD"),
        Locale("ko", "KR"),
        Locale("ru", "RU"),
        Locale("ja", "JP"),
        Locale("uk", "UA"),
        Locale("zh", "US"),
        Locale("bn", "US"),
        Locale("ko", "US"),
        Locale("ru", "US"),
        Locale("ja", "US"),
        Locale("uk", "US"),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          // TODO: used to be a fix to iOS error; maybe fixed bc of CFBundleLocalizations in iOS/Runner/info.plist
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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
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

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)
            .translate(_widgetOptions[_selectedIndex]['title'])),
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
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
