import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
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
        stream: APIConnect.proposalListView,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return Scaffold(
                body: ListView(
                  padding: const EdgeInsets.all(4),
                  children: snapshot.data,
                ),
                floatingActionButton: getFAB(
                  context,
                  CreateProposal(APIConnect.addProposal),
                ),
              );
          }
        },
      ),
    );
  }
}
