import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/loader.dart';
import 'package:Solon/proposal/card.dart';
import 'package:Solon/proposal/create.dart';

class ProposalsScreen extends StatefulWidget {
  final int uid;
  ProposalsScreen({Key key, this.uid}) : super(key: key);
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> with Screen {
  final translator = GoogleTranslator();

  Stream<List<ProposalCard>> stream;

  @override
  void initState() {
    super.initState();

    stream = APIConnect.proposalListView;
  }

  Future<void> getStream() async {
    setState(() {
      stream = APIConnect.proposalListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getStream,
      child: StreamBuilder<List<ProposalCard>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
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
                  floatingActionButton:
                      getFAB(context, CreateProposal(APIConnect.addProposal)),
                );
              }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
