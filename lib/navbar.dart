import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;

  NavBar(this.selectedIndex, this.onItemTapped);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Proposals'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: Text('Events'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          title: Text('Forum'),
        )
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.pinkAccent[400],
      onTap: onItemTapped,
    );
  }
}
