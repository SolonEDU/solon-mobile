import 'package:Solon/api/api_connect.dart';
import 'package:Solon/loader.dart';
import 'package:Solon/proposal/card.dart';
import 'package:Solon/proposal/create.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class ProposalsScreen extends StatefulWidget {
  final int uid;
  ProposalsScreen({Key key, this.uid}) : super(key: key);
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  final translator = GoogleTranslator();

  Future<String> translateText(text, code) async {
    return await translator.translate(text, to: code);
  }

  Future<List<Map>> translateAll(String title, String description,
      List<Map> maps, Map<String, String> languages) async {
    for (var language in languages.keys) {
      maps[0][language] = await translateText(title, languages[language]);
      maps[1][language] = await translateText(description, languages[language]);
    }
    return maps;
  }

  // void _addProposal(
  //   String title,
  //   String description,
  //   double daysLeft,
  //   DateTime endDate,
  // ) async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   Map<String, String> languages = {
  //     'English': 'en',
  //     'Chinese (Simplified)': 'zh-cn',
  //     'Chinese (Traditional)': 'zh-tw',
  //     'Bengali': 'bn',
  //     'Korean': 'ko',
  //     'Russian': 'ru',
  //     'Japanese': 'ja',
  //     'Ukrainian': 'uk'
  //   };
  //   Map<String, String> translatedTitles = {};
  //   Map<String, String> translatedDescriptions = {};
  //   List<Map> translated = [translatedTitles, translatedDescriptions];
  //   translated = await translateAll(title, description, translated, languages);
  //   db.collection('proposals').add(
  //     {
  //       'title': translated[0],
  //       'description': translated[1],
  //       'daysLeft': daysLeft,
  //       'endDate': endDate.toString(),
  //       'creator': user.uid,
  //     },
  //   );
  // }

  // Future<List> toNativeLanguage(DocumentSnapshot doc) async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   DocumentSnapshot userData =
  //       await db.collection('users').document(user.uid).get();
  //   String nativeLanguage = userData.data['nativeLanguage'];
  //   List translatedProposal = List();
  //   translatedProposal.add(doc.data['title'][nativeLanguage]);
  //   translatedProposal.add(doc.data['description'][nativeLanguage]);
  //   return translatedProposal;
  // }

  // Widget buildProposal(doc) {
  //   return FutureBuilder(
  //     future: toNativeLanguage(doc),
  //     builder: (BuildContext context, AsyncSnapshot<List> translatedProposal) {
  //       return Proposal(
  //         key: UniqueKey(),
  //         title: translatedProposal.hasData ? translatedProposal.data[0] : '',
  //         descripton:
  //             translatedProposal.hasData ? translatedProposal.data[1] : '',
  //         daysLeft: doc.data['daysLeft'],
  //         endDate: DateTime.parse(doc.data['endDate']),
  //         numYea: 0,
  //         numNay: 0,
  //         doc: doc,
  //         // creator: doc.data['creator']
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProposalCard>>(
      stream: APIConnect.proposalListView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: ListView(
                    children: snapshot.data,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: 'unq1',
                  child: Icon(Icons.add),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateProposal(APIConnect.addProposal),
                      ),
                    )
                  },
                ),
              );
            }
        }
        return Center(
          child: Loader(),
        );
      },
    );
  }
}
