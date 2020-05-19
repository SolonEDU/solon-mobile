import 'package:Solon/util/app_localizations.dart';
import 'package:flutter/material.dart';

mixin DropdownUtil {
  static TextStyle dropdownMenuTextStyle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 17,
  );

  static List<DropdownMenuItem<String>> getProposalDropdownItems(
    BuildContext context,
  ) {
    return <String>[
      'Most votes',
      'Least votes',
      'Newly created',
      'Oldest created',
      'Upcoming deadlines',
      'Furthest deadlines',
    ].map<DropdownMenuItem<String>>((String value) {
      Map<String, String> itemsMap = {
        'Most votes': AppLocalizations.of(context).translate("mostVotes"),
        'Least votes': AppLocalizations.of(context).translate("leastVotes"),
        'Newly created': AppLocalizations.of(context).translate("newlyCreated"),
        'Oldest created':
            AppLocalizations.of(context).translate("oldestCreated"),
        'Upcoming deadlines':
            AppLocalizations.of(context).translate("upcomingDeadlines"),
        'Furthest deadlines':
            AppLocalizations.of(context).translate("furthestDeadlines"),
      };
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          itemsMap[value],
          style: dropdownMenuTextStyle,
        ),
      );
    }).toList();
  }

  static List<DropdownMenuItem<String>> getEventDropdownItems(
    BuildContext context,
  ) {
    return <String>[
      'Furthest',
      'Upcoming',
      'Most attendees',
      'Least attendees',
    ].map<DropdownMenuItem<String>>((String value) {
      Map<String, String> itemsMap = {
        'Furthest': AppLocalizations.of(context).translate("furthest"),
        'Upcoming': AppLocalizations.of(context).translate("upcoming"),
        'Most attendees':
            AppLocalizations.of(context).translate("mostAttendees"),
        'Least attendees':
            AppLocalizations.of(context).translate("leastAttendees"),
      };
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          itemsMap[value],
          style: dropdownMenuTextStyle,
        ),
      );
    }).toList();
  }

  static List<DropdownMenuItem<String>> getForumDropdownItems(
    BuildContext context,
  ) {
    return <String>[
      'Newly created',
      'Oldest created',
      'Most comments',
      'Least comments',
    ].map<DropdownMenuItem<String>>((String value) {
      Map<String, String> itemsMap = {
        'Newly created': AppLocalizations.of(context).translate("newlyCreated"),
        'Oldest created':
            AppLocalizations.of(context).translate("oldestCreated"),
        'Most comments': AppLocalizations.of(context).translate("mostComments"),
        'Least comments':
            AppLocalizations.of(context).translate("leastComments"),
      };
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          itemsMap[value],
          style: dropdownMenuTextStyle,
        ),
      );
    }).toList();
  }
}
