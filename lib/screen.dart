import 'package:flutter/material.dart';
import 'generated/i18n.dart';

typedef APIFunction<T> = Future<T> Function();

mixin Screen {
  void showToast(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  FloatingActionButton getFAB(
      BuildContext context, Widget creator) {
    return FloatingActionButton(
      heroTag: 'unq1',
      backgroundColor: Colors.pinkAccent[400],
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => creator),
        );
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
        (title != null) ? title : '',
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

  Column getVoteBar(BuildContext context, int yes, int no) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          child: Text(''),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.green,
                Colors.red,
                Colors.red,
              ],
              stops: [0, yes / (yes + no), yes / (yes + no), 1.0],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                I18n.of(context).numYes(yes.toString()),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                I18n.of(context).numNo(no.toString()),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
