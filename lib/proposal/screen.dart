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
    String dropdownValue = 'Most votes';
    return RefreshIndicator(
      onRefresh: getStream,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Sort by: "),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.pink[400],
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  'Most votes',
                  'Least votes',
                  'Newly created',
                  'Oldest created',
                  'Upcoming deadlines',
                  'Oldest deadlines',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<ProposalCard>>(
              stream: APIConnect.proposalListView,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  default:
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Scaffold(
                        body: ListView(
                          padding: const EdgeInsets.all(4),
                          children: snapshot.data,
                        ),
                        floatingActionButton: getFAB(
                          context,
                          CreateProposal(APIConnect.addProposal),
                          getStream,
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
