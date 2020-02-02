import 'package:flutter/material.dart';

mixin Screen {
  void showToast(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  FloatingActionButton getFAB(BuildContext context, Widget creator, Function getStream) {
    return FloatingActionButton(
      heroTag: 'unq1',
      backgroundColor: Colors.pinkAccent[400],
      child: Icon(Icons.add),
      onPressed: () async {
        final received = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => creator),
        );
        Future.delayed(
          Duration(
            seconds: 2,
          ),
          () => getStream(),
        );
        print(received);
      },
    );
  }

  AppBar getPageAppBar(BuildContext context, {String title}) {
    return AppBar(
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.black,
        onPressed: () => {
          FocusScope.of(context).unfocus(),
          Navigator.pop(context),
        },
      ),
      title: Text(
        (title != null)
        ? title
        : '',
      ),
    );
  }

  Container getCard(BuildContext context, ListTile tile, Function function) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: MediaQuery.of(context).size.width - 10,
      ),
      child: Align(
        child: SizedBox(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30),
            ),
            color: Colors.white,
            child: tile,
            onPressed: function,
          ),
        ),
      ),
    );
  }
}
