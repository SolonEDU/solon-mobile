import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  final Function _addEvent;
  CreateEvent(this._addEvent);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime _date = DateTime.now();
  int _currentStep = 0;
  FocusNode _focusNode;

  List<TextEditingController> controllers =
      List.generate(3, (int index) => TextEditingController());


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  goTo(int step) {
    setState(() => {_currentStep = step});
    if (step == 2) _selectDate(context);
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2020),
    );

    if (picked != null) {
      setState(() {
        _date = picked;
      });
      _selectTime(context);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _date = new DateTime(_date.year, _date.month ,_date.day, picked.hour, picked.minute);
      });
    }
    controllers[2].text =
        "Event occurs on ${new DateFormat.yMMMMd("en_US").add_jm().format(_date)}";
  }

  @override
  Widget build(BuildContext context) {
    List<Step> form = [
      Step(
        title: const Text('Title'),
        isActive: _currentStep == 0 ? true : false,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
          controller: controllers[0],
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
        title: const Text('Description'),
        isActive: _currentStep == 1 ? true : false,
        state: _currentStep == 1
            ? StepState.editing
            : _currentStep < 1 ? StepState.disabled : StepState.complete,
        content: TextFormField(
          autofocus: true,
          focusNode: _focusNode,
          decoration: const InputDecoration(labelText: 'Description'),
          controller: controllers[1],
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
        title: const Text('Date and Time'),
        isActive: _currentStep == 2 ? true : false,
        state: _currentStep == 2
            ? StepState.editing
            : _currentStep < 2 ? StepState.disabled : StepState.complete,
        content: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Date and Time'),
              controller: controllers[2],
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
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Event'),
      ),
      body: Stepper(
        steps: form,
        currentStep: _currentStep,
        onStepContinue: () => {
          _currentStep + 1 != form.length
              ? {
                  if (controllers[_currentStep].text.length > 0)
                    {
                      goTo(_currentStep + 1),
                      FocusScope.of(context).requestFocus(_focusNode)
                    }
                }
              : {
                  widget._addEvent(controllers[0].text,
                      controllers[2].text, _date),
                  controllers.forEach((controller) => {controller.clear()}),
                  Navigator.pop(context),
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
