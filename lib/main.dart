import 'package:flutter/material.dart';
import 'package:solon/home_screen.dart';

import './navbar.dart';
import './proposals_screen.dart';
import './events_screen.dart';
import './forum_screen.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
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
    {'title': Text('Forum'), 'widget': ForumScreen()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return DecoratedBox(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  }, child: null,
                ),
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
        body: Center(
          child: _widgetOptions[_selectedIndex]['widget'],
        ),
        bottomNavigationBar: NavBar(_selectedIndex, _onItemTapped),
      ),
    );
  }
}
