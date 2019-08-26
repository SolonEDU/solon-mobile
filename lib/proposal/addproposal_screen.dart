import 'package:flutter/material.dart';

class AddProposalScreen extends StatelessWidget {
  final Function addProposal;
  AddProposalScreen(this.addProposal);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Proposal'),
      ),
      body: AddProposalForm(addProposal),
    );
  }
}

// Create a Form widget.
class AddProposalForm extends StatefulWidget {
  final Function addProposal;
  AddProposalForm(this.addProposal);
  @override
  AddProposalFormState createState() {
    return AddProposalFormState(addProposal);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddProposalFormState extends State<AddProposalForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final Function addProposal;
  final proposalTitleController = TextEditingController();
  final proposalSubtitleController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _currentStep = 0;

  AddProposalFormState(this.addProposal);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
    );

    if(picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Proposal'),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: proposalTitleController,
          ),
          Text('Description'),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: proposalSubtitleController,
          ),
          RaisedButton(
            child: Text('Select Date'),
            onPressed: () {
              _selectDate(context);
            },
          ),
          Text('Vote ends on ${_date.toString()}'),
          RaisedButton(
            child: Text('Select Time'),
            onPressed: () {
              _selectTime(context);
            },
          ),
          Text('Vote ends on ${_time.toString()}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  addProposal(proposalTitleController.text, proposalSubtitleController.text, _date, _time);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}