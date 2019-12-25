import 'package:flutter/material.dart';
import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/app_localizations.dart';
import 'package:Solon/loader.dart';

class ProposalPage extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final int uidUser;
  final String endTime;

  ProposalPage({
    Key key,
    this.pid,
    this.title,
    this.description,
    this.uidUser,
    this.endTime,
  }) : super(key: key);

  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  String _voteOutput;
  Future<Map<String, dynamic>> _listFutureProposal;

  Future<Map<String, dynamic>> getVote() async {
    final responseMessage = await APIConnect.connectVotes(
      'GET',
      pid: widget.pid,
      uidUser: widget.uidUser,
    );
    return responseMessage;
  }

  @override
  void initState() {
    super.initState();

    _listFutureProposal = getVote();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pid);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Map<String, dynamic>>(
              future: _listFutureProposal,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Loader(),
                  );
                }
                if (snapshot.data['message'] == 'Error') {
                  _voteOutput = "You have not voted yet!";
                } else {
                  _voteOutput = snapshot.data['vote']['value'] == 1
                      ? "You have voted Yea!"
                      : "You have voted Nay!";
                }
                print(snapshot.data['message']);
                return ListView(
                  children: <Widget>[
                    Text(widget.description),
                    Text('Voting on proposal ends ' + widget.endTime),
                    // Text(AppLocalizations.of(context).translate('votesFor')),
                    snapshot.data['message'] == 'Error'
                        ? PreventDoubleTap(
                            pid: widget.pid,
                            uidUser: widget.uidUser,
                            voted: snapshot.data['message'] == 'Error'
                                ? false
                                : true,
                          )
                        : Text(_voteOutput),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class PreventDoubleTap extends StatefulWidget {
  final int pid;
  final int uidUser;
  final bool voted;

  PreventDoubleTap({
    Key key,
    this.pid,
    this.uidUser,
    this.voted,
  }) : super(key: key);

  @override
  PreventDoubleTapState createState() {
    return new PreventDoubleTapState();
  }
}

class PreventDoubleTapState extends State<PreventDoubleTap> {
  //boolean value to determine whether button is tapped
  bool _isButtonTapped = false;

  Future<void> vote(int pid, int uidUser, int voteVal) async {
    APIConnect.connectVotes('POST',
        pid: pid, uidUser: uidUser, voteVal: voteVal);
    // print(responseMessage['message']);
  }

  _onYeaTapped() async {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    print('is button tapped? yea $_isButtonTapped');
    vote(widget.pid, widget.uidUser, 1);
  }

  _onNayTapped() async {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    print('is button tapped? nay $_isButtonTapped');
    vote(widget.pid, widget.uidUser, 0);
  }

  @override
  Widget build(BuildContext context) {
    print('is button tapped? build $_isButtonTapped');
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      RaisedButton(
        color: Colors.red,
        child: Text('Yea'),
        onPressed: _isButtonTapped
            ? null
            : _onYeaTapped, //if button hasnt being tapped, allow user tapped. else, dont allow
      ),
      RaisedButton(
        color: Colors.red,
        child: Text('Nay'),
        onPressed: _isButtonTapped
            ? null
            : _onNayTapped, //if button hasnt being tapped, allow user tapped. else, dont allow
      ),
    ]);
  }
}
