import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:Solon/api/api_connect.dart';
import 'package:Solon/event/card.dart';
// import 'package:Solon/loader.dart';

class EventsScreen extends StatefulWidget {
  final int uid;
  EventsScreen({Key key, this.uid}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final translator = GoogleTranslator();
  Stream<List<EventCard>> stream;

  @override
  void initState() {
    super.initState();

    stream = APIConnect.eventListView(widget.uid);
  }

  Future<void> getStream() async {
    setState(() {
      stream = APIConnect.eventListView(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getStream,
      child: StreamBuilder<List<EventCard>>(
        stream: Function.apply(
          APIConnect.eventListView,
          [widget.uid],
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return Scaffold(
                body: Center(
                  child: ListView(
                    padding: EdgeInsets.all(8),
                    children: <Widget>[
                      Column(
                        children: snapshot.data,
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
