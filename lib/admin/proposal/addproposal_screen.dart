import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

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
        "Proposal ends on ${_date.toString().substring(0, 10)} at ${_time.toString().substring(10, 15)}";
  }

  @override
  Widget build(BuildContext context) {
    form = [
      Step(
        title: Text(AppLocalizations.of(context).translate('title')),
        isActive: _currentStep == 0 ? true : false,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('title')),
          controller: proposalTitleController,
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).translate('pleaseEnterATitle');
            }
            return null;
          },
        ),
      ),
      Step(
          title: Text(AppLocalizations.of(context).translate('description')),
          isActive: _currentStep == 1 ? true : false,
          state: _currentStep == 1
              ? StepState.editing
              : _currentStep < 1 ? StepState.disabled : StepState.complete,
          content: TextFormField(
            autofocus: true,
            focusNode: myFocusNode,
            decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('description')),
            controller: proposalSubtitleController,
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return AppLocalizations.of(context).translate('pleaseEnterADescription');
              }
              return null;
            },
          )),
      Step(
        title: Text(AppLocalizations.of(context).translate('dateAndTime')),
        isActive: _currentStep == 2 ? true : false,
        state: _currentStep == 2
            ? StepState.editing
            : _currentStep < 2 ? StepState.disabled : StepState.complete,
        content: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('dateAndTime')),
              controller: proposalTimeController,
              autovalidate: true,
              validator: (value) {
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('pleaseChooseADateAndTime');
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text(AppLocalizations.of(context).translate('selectDateAndTime')),
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
                addProposal(
                    proposalTitleController.text,
                    proposalSubtitleController.text,
                    _date,
                    _time),
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
  }
}
