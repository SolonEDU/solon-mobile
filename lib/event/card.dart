import 'package:flutter/material.dart';

import './page.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String description;
  final String time;
  EventCard(this.title, this.description, this.time);

  @override
  _EventCardState createState() => _EventCardState(title, description, time);
}

class _EventCardState extends State<EventCard> {
  final String title;
  final String description;
  final String time;
  bool attending = false;

  _EventCardState(
    this.title,
    this.description,
    this.time,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(title),
              subtitle: Text(description + '\n' + time),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      title,
                      description,
                      time,
                    ),
                  ),
                );
              },
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  Switch.adaptive(
                    value: attending,
                    onChanged: (value) {
                      setState(
                        () => attending = value,
                      );
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text('Attending?')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
