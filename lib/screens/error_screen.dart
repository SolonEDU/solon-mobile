import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Function() notifyParent;
  final Exception error;

  ErrorScreen({
    Key key,
    @required this.notifyParent,
    @required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        // TODO: need to center this
        child: ListView(
          children: <Widget>[
            Text('An error occurred!'),
            Text('$error'),
            Button(
              color: Colors.pink[200],
              height: 55,
              label: AppLocalizations.of(context).translate('reload'),
              margin: EdgeInsets.only(top: 10),
              function: notifyParent,
            ),
          ],
        ),
      ),
    );
  }
}
