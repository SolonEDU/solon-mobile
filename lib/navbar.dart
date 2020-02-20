import 'package:Solon/app_localizations.dart';
import 'package:Solon/generated/i18n.dart';
import 'package:flutter/material.dart';

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
          title: Text(AppLocalizations.of(context).translate("home")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          title: Text(I18n.of(context).proposals),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: Text(I18n.of(context).events),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          title: Text(I18n.of(context).forum),
        )
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.pinkAccent[400],
      onTap: onItemTapped,
    );
  }
}