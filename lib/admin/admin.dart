import 'package:flutter/material.dart';

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
      'title': Text('Home'),
      'widget': AdminHomeScreen(),
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
