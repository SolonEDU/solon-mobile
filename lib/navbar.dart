import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;

  NavBar(this.selectedIndex, this.onItemTapped);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(AppLocalizations.of(context).translate('home')),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          title: Text(AppLocalizations.of(context).translate('proposals')),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: Text(AppLocalizations.of(context).translate('events')),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          title: Text(AppLocalizations.of(context).translate('forum')),
        )
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.pinkAccent[400],
      onTap: onItemTapped,
    );
  }
}