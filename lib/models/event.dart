import 'dart:convert';

import 'package:Solon/models/model.dart';
import 'package:date_format/date_format.dart';

class Event extends Model{
  final int eid;
  final String title;
  final String description;
  final String date;
  final bool attending;
  final int numattenders;

  Event({
    this.eid,
    this.title,
    this.description,
    this.date,
    this.attending,
    this.numattenders,
  });

  factory Event.fromJson({
    Map<String, dynamic> map,
    String prefLangCode,
  }) {
    DateTime date = DateTime.parse(map['date']);
    String dateParsed =
        formatDate(date, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return Event(
      eid: map['eid'],
      title: translatedTitle,
      description: translatedDescription,
      date: dateParsed,
      numattenders: map['numattenders'],
    );
  }
}
