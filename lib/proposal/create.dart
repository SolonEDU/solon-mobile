import 'package:Solon/auth/button.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';

class CreateProposal extends StatefulWidget {
  final Function _addProposal;
  CreateProposal(this._addProposal);

  @override
  _CreateProposalState createState() => _CreateProposalState();
}

class _CreateProposalState extends State<CreateProposal> with Screen {
  String _title, _description;
  double _sliderValue = 7.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getPageAppBar(context, 'New Proposal'),
      key: _scaffoldKey,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            primary: false,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  AppLocalizations.of(context).translate('title'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('pleaseEnterATitle');
                    }
                    return null;
                  },
                  onSaved: (input) => _title = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child:
                    Text(AppLocalizations.of(context).translate('description')),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 30, top: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink[400],
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('pleaseEnterADescription');
                    }
                    return null;
                  },
                  onSaved: (input) => _description = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text('Days Until Proposal Ends'),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35.0),
                child: Slider(
                  activeColor: Colors.pink[400],
                  divisions: 13,
                  label: _sliderValue == 1.0
                      ? '${_sliderValue.round()} Day'
                      : '${_sliderValue.round()} Days',
                  min: 1.0,
                  max: 14.0,
                  onChanged: (newRating) {
                    setState(() => _sliderValue = newRating);
                  },
                  value: _sliderValue,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "1 Day",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "14 Days",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Button(
                width: 255,
                height: 55,
                function: createProposal,
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                label: 'Create Proposal',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createProposal() async {
    DateTime _date = DateTime.now();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      widget._addProposal(
          _title,
          _description,
          _date,
          _date.add(
            new Duration(
              days: _sliderValue.toInt(),
            ),
          ),
          0); //dummy uid
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, APIConnect.connectProposals());
      Future.delayed(
        const Duration(milliseconds: 500),
      );
    }
  }
}
