import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  // final _formKey = GlobalKey<FormState>();
  final Function addProposal;

  bool complete;

  static var proposalTitleController = TextEditingController();
  static var proposalSubtitleController = TextEditingController();
  static var proposalTimeController = TextEditingController();
  final controllers = [
    proposalTitleController,
    proposalSubtitleController,
    proposalTimeController
  ];

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _currentStep = 0;
  List<Step> form = [];

  AddProposalFormState(this.addProposal);

  void goTo(int step) {
    setState(() => _currentStep = step);
    if (step == 2) _selectDate(context);
  }

  Future<Null> _selectDate(BuildContext context) async {
    var now = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2020),
    );

    if (picked != null) {
      print('Date selected: ${_date.toString()}');
      _selectTime(context);
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

    if (picked != null) {
      print('Time selected: ${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
    proposalTimeController.text =
      "Proposal ends on ${new DateFormat.yMMMMd("en_US").add_jm().format(_date)}";
  }

  @override
  Widget build(BuildContext context) {
    form = [
      Step(
        title: Text('Title'),
        isActive: _currentStep == 0 ? true : false,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
          controller: proposalTitleController,
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ),
      Step(
          title: Text('Description'),
          isActive: _currentStep == 1 ? true : false,
          state: _currentStep == 1
              ? StepState.editing
              : _currentStep < 1 ? StepState.disabled : StepState.complete,
          content: TextFormField(
            autofocus: true,
            focusNode: myFocusNode,
            decoration: const InputDecoration(labelText: 'Description'),
            controller: proposalSubtitleController,
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          )),
      Step(
        title: Text('Date and Time'),
        isActive: _currentStep == 2 ? true : false,
        state: _currentStep == 2
            ? StepState.editing
            : _currentStep < 2 ? StepState.disabled : StepState.complete,
        content: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Date and Time'),
              controller: proposalTimeController,
              autovalidate: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please choose a date and time';
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text('Select Date and Time'),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    ];

    return Stepper(
      steps: form,
      currentStep: _currentStep,
      onStepContinue: () => {
        _currentStep + 1 != form.length
            ? {
                if (controllers[_currentStep].text.length > 0)
                  {
                    goTo(_currentStep + 1),
                    FocusScope.of(context).requestFocus(myFocusNode)
                  }
              }
            : {
                setState(() => complete = true),
                addProposal(proposalTitleController.text,
                    proposalSubtitleController.text, _date, _time),
                proposalTitleController.text = '',
                proposalSubtitleController.text = '',
                proposalTimeController.text = '',
                Navigator.pop(context),
              }
      },
      onStepCancel: () => {
        if (_currentStep > 0) {goTo(_currentStep - 1)}
      },
      onStepTapped: (step) => goTo(step),
    );
    // Build a Form widget using the _formKey created above.
    // return Form(
    //   key: _formKey,
    //   child: ListView(
    //     //crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Text('Proposal'),
    //       TextFormField(
    //         validator: (value) {
    //           if (value.isEmpty) {
    //             return 'Please enter some text';
    //           }
    //           return null;
    //         },
    //         controller: proposalTitleController,
    //       ),
    //       Text('Description'),
    //       TextFormField(
    //         validator: (value) {
    //           if (value.isEmpty) {
    //             return 'Please enter some text';
    //           }
    //           return null;
    //         },
    //         controller: proposalSubtitleController,
    //       ),
    //       RaisedButton(
    //         child: Text('Select Date'),
    //         onPressed: () {
    //           _selectDate(context);
    //         },
    //       ),
    //       Text('Vote ends on ${_date.toString()}'),
    //       RaisedButton(
    //         child: Text('Select Time'),
    //         onPressed: () {
    //           _selectTime(context);
    //         },
    //       ),
    //       Text('Vote ends on ${_time.toString()}'),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 16.0),
    //         child: RaisedButton(
    //           onPressed: () {
    //             // Validate returns true if the form is valid, or false
    //             // otherwise.
    //             if (_formKey.currentState.validate()) {
    //               // If the form is valid, display a Snackbar.
    //               Scaffold.of(context)
    //                   .showSnackBar(SnackBar(content: Text('Processing Data')));
    //               addProposal(
    //                 proposalTitleController.text,
    //                 proposalSubtitleController.text,
    //                 _date,
    //                 _time,
    //               );
    //               Navigator.pop(context);
    //             }
    //           },
    //           child: Text('Submit'),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
