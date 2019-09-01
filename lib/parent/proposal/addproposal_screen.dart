import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

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
  DateTime _date = DateTime.now();
  var _currentStep = 0;
  List<Step> form = [];

  static var proposalTitleController = TextEditingController();
  static var proposalSubtitleController = TextEditingController();
  static var proposalTimeController = TextEditingController();
  final controllers = [
    proposalTitleController,
    proposalSubtitleController,
    proposalTimeController
  ];

  // This is the starting value of the slider.
  double _sliderValue = 7.0;

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

  AddProposalFormState(this.addProposal);

  void goTo(int step) {
    setState(() => _currentStep = step);
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
        ),
      ),
      Step(
        title: Text('Days Until Voting on Proposal Ends'),
        isActive: _currentStep == 2 ? true : false,
        state: _currentStep == 2
            ? StepState.editing
            : _currentStep < 2 ? StepState.disabled : StepState.complete,
        content: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 45.0),
              child: Slider(
                activeColor: Colors.blue,
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
              margin: const EdgeInsets.only(bottom: 45.0),
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
                    _currentStep == 2 
                    ? myFocusNode.unfocus()
                    : FocusScope.of(context).requestFocus(myFocusNode)
                  }
              }
            : {
                addProposal(
                    proposalTitleController.text,
                    proposalSubtitleController.text,
                    _sliderValue,
                    _date.add(new Duration(days: _sliderValue.toInt()))),
                proposalTitleController.text = '',
                proposalSubtitleController.text = '',
                proposalTimeController.text = '',
                Navigator.pop(context,true),
              }
      },
      onStepCancel: () => {
        if (_currentStep > 0) {goTo(_currentStep - 1)}
      },
      onStepTapped: (step) => goTo(step),
    );
  }
}
