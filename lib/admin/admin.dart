import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

import '../navbar.dart';
import 'package:Solon/admin/home_screen.dart';
import './proposal/proposals_screen.dart';
import './event/screen.dart';
import './forum/screen.dart';

class Admin extends StatefulWidget {
  Admin({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AdminState();
  }
}

class _AdminState extends State<Admin> {
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var _widgetOptions = [
    {
      'title': 'home',
      'widget': AdminHomeScreen(),
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
