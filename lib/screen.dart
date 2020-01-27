import 'package:flutter/material.dart';

mixin Screen {
  void showToast(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  FloatingActionButton getFAB(BuildContext context, Widget creator) {
    return FloatingActionButton(
      heroTag: 'unq1',
      backgroundColor: Colors.pinkAccent[400],
      child: Icon(Icons.add),
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => creator,
          ),
        )
      },
    );
  }
}
