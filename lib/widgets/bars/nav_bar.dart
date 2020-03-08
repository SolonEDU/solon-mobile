import 'package:flutter/material.dart';
import 'package:Solon/util/app_localizations.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;

  NavBar({this.selectedIndex, this.onItemTapped});

  static TextStyle navbarTextStyle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 17,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              AppLocalizations.of(context).translate("home"),
              style: navbarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: Text(
              AppLocalizations.of(context).translate("proposals"),
              style: navbarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text(
              AppLocalizations.of(context).translate("events"),
              style: navbarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            title: Text(
              AppLocalizations.of(context).translate("forum"),
              style: navbarTextStyle,
            ),
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.pinkAccent[400],
        onTap: onItemTapped,
      ),
    );
  }
}
