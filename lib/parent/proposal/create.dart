import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:Solon/app_localizations.dart';

class CreateProposal extends StatefulWidget {
  final Function _addProposal;
  CreateProposal(this._addProposal);

  @override
  _CreateProposalState createState() => _CreateProposalState();
}

class _CreateProposalState extends State<CreateProposal> {
  DateTime _date = DateTime.now();
  int _currentStep = 0;
  FocusNode _focusNode = FocusNode();
  double _sliderValue = 7.0;

  List<TextEditingController> controllers =
      List.generate(2, (int index) => TextEditingController());

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void goTo(int step) {
    setState(() => _currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    List<Step> form = [
      Step(
        title: Text(AppLocalizations.of(context).translate('title')),
        isActive: _currentStep == 0 ? true : false,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('title')),
          controller: controllers[0],
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
          focusNode: _focusNode,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('description')),
          controller: controllers[1],
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).translate('pleaseEnterADescription');
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
    return Scaffold(
      appBar: AppBar(title: Text('Add Proposal')),
      body: Stepper(
        steps: form,
        currentStep: _currentStep,
        onStepContinue: () => {
          _currentStep + 1 != form.length
              ? {
                  if (controllers[_currentStep].text.isNotEmpty)
                    {
                      goTo(_currentStep + 1),
                      _currentStep == 2
                          ? _focusNode.unfocus()
                          : FocusScope.of(context).requestFocus(_focusNode)
                    }
                }
              : {
                  widget._addProposal(
                      controllers[0].text,
                      controllers[1].text,
                      _sliderValue,
                      _date.add(new Duration(days: _sliderValue.toInt()))),
                  controllers.forEach((controller) => {controller.clear()}),
                  Navigator.pop(context, true),
                }
        },
        onStepCancel: () => {
          if (_currentStep > 0) {goTo(_currentStep - 1)}
        },
        onStepTapped: (step) => goTo(step),
      ),
    );
  }
}
