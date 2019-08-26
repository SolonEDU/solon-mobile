import 'package:flutter/material.dart';
import 'package:solon/home_screen.dart';
import 'package:flutter/services.dart';

import './navbar.dart';
import './proposal/proposals_screen.dart';
import './event/screen.dart';
import './forum/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: _title,
      home: Main(),
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
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var _widgetOptions = [
    {
      'title': Text('Home'),
      'widget': HomeScreen(),
    },
    {
      'title': Text('Proposals'),
      'widget': ProposalsScreen(),
    },
    {
      'title': Text('Events'),
      'widget': EventsScreen(),
    },
    {
      'title': Text('Forum'),
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
        title: _widgetOptions[_selectedIndex]['title'],
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

