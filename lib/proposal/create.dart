import 'package:Solon/api/message.dart';
import 'package:Solon/doubletap.dart';
import 'package:Solon/generated/i18n.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';

typedef APIFunction<T> = Future<T> Function(
  String,
  String,
  DateTime,
  DateTime,
  int,
);

class CreateProposal extends StatefulWidget {
  final APIFunction<Message> _addProposal;
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
      appBar: getPageAppBar(context, title: I18n.of(context).newProposal),
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
                  I18n.of(context).title,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return I18n.of(context).pleaseEnterATitle;
                    }
                    return null;
                  },
                  onSaved: (input) => _title = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(I18n.of(context).description),
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
                      return I18n.of(context).pleaseEnterADescription;
                    }
                    return null;
                  },
                  onSaved: (input) => _description = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(I18n.of(context).daysUntilProposalEnds),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35.0),
                child: Slider(
                  activeColor: Colors.pink[400],
                  divisions: 13,
                  label: _sliderValue == 1.0
                      ? I18n.of(context).lowerBoundDays(_sliderValue.round().toString())
                      : I18n.of(context).upperBoundDays(_sliderValue.round().toString()),
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
                      I18n.of(context).lowerBoundDays("1"),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      I18n.of(context).upperBoundDays("14"),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              PreventDoubleTap(
                body: <Map>[
                  {
                    "color": Colors.pink[200],
                    "width": 255.0,
                    "height": 55.0,
                    "function": createProposal,
                    "margin": const EdgeInsets.only(top: 25, bottom: 10),
                    "label": I18n.of(context).createProposal,
                  }
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<bool> createProposal() async* {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      yield true;
      formState.save();
      DateTime _date = DateTime.now();
      widget
          ._addProposal(
              _title,
              _description,
              _date,
              _date.add(new Duration(days: _sliderValue.toInt())),
              0) // 0 is a dummy uid
          .then(
        (message) {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
        },
      );
    } else {
      yield false;
    }
  }
}
