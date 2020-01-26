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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Raleway',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 20),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: APIConnect.connectSharedPreferences(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            // print(snapshot.data);
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
  // final db = Firestore.instance;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // leading: Text(),
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return DecoratedBox(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage('images/solon.png'),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        title: Text(
          AppLocalizations.of(context)
              .translate(_widgetOptions[_selectedIndex]['title']),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            // fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        actions: <Widget>[
          FloatingActionButton(
            heroTag: 'unq0',
            elevation: 0.0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.pinkAccent[400],
            child: Icon(Icons.account_circle),
            onPressed: () async {
              // FirebaseUser user = await FirebaseAuth.instance.currentUser();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(uid: widget.uid),
                ),
              );
            },
          ),
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
