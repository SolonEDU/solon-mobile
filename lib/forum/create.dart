import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  final Function _addPost;
  CreatePost(this._addPost);

  @override
  _CreatePostState createState() => _CreatePostState(_addPost);
}

class _CreatePostState extends State<CreatePost> {
  List<Step> form = [];
  // final _formKey = GlobalKey<FormState>();
  final Function addPost;
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

  static var titleController = TextEditingController();
  static var descriptionController = TextEditingController();
  static var controllers = [
    titleController,
    descriptionController,
  ];

  //DateTime _date = DateTime.now();
  //TimeOfDay _time = TimeOfDay.now();

  int currentStep = 0;
  bool complete = false;

  goTo(int step) {
    setState(() => {currentStep = step});
  }

  _CreatePostState(this.addPost);

  // Future<Null> _selectDate(BuildContext context) async {
  //   DateTime now = DateTime.now();
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: _date,
  //     firstDate: DateTime(now.year, now.month, now.day),
  //     lastDate: DateTime(2020),
  //   );

  //   if (picked != null && picked != _date) {
  //     print('Date selected: ${_date.toString()}');
  //     setState(() {
  //       _date = picked;
  //     });
  //   }

  //   _selectTime(context);
  // }

  // Future<Null> _selectTime(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(
  //     context: context,
  //     initialTime: _time,
  //   );

  //   if (picked != null && picked != _time) {
  //     print('Time selected: ${_time.toString()}');
  //     setState(() {
  //       _time = picked;
  //     });
  //   }
  //   timeController.text =
  //       "Event occurs on ${_date.toString().substring(0, 10)} at ${_time.toString().substring(10, 15)}";
  // }

  @override
  Widget build(BuildContext context) {
    form = [
      Step(
        title: const Text('Title'),
        isActive: currentStep == 0 ? true : false,
        state: currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
          controller: titleController,
          autovalidate: true,
          // validator: (value) {
          //   if (value.isEmpty) {
          //     return 'Please enter a title';
          //   }
          //   return null;
          // },
        ),
      ),
      Step(
        title: const Text('Description'),
        isActive: currentStep == 1 ? true : false,
        state: currentStep == 1
            ? StepState.editing
            : currentStep < 1 ? StepState.disabled : StepState.complete,
        content: TextFormField(
          autofocus: true,
          focusNode: myFocusNode,
          decoration: const InputDecoration(labelText: 'Description'),
          controller: descriptionController,
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ),
      // Step(
      //   title: const Text('Date and Time'),
      //   isActive: currentStep == 2 ? true : false,
      //   state: currentStep == 2
      //       ? StepState.editing
      //       : currentStep < 2 ? StepState.disabled : StepState.complete,
      //   content: Column(
      //     children: <Widget>[
      //       TextFormField(
      //         autofocus: true,
      //         decoration: const InputDecoration(labelText: 'Date and Time'),
      //         controller: timeController,
      //         autovalidate: true,
      //         validator: (value) {
      //           if (value.isEmpty) {
      //             return 'Please choose a date and time';
      //           }
      //           return null;
      //         },
      //       ),
      //       RaisedButton(
      //         child: Text('Select Date and Time'),
      //         onPressed: () => _selectDate(context),
      //       ),
      //     ],
      //   ),
      // )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Event'),
      ),
      body: Stepper(
        // key: _formKey,
        steps: form,
        currentStep: currentStep,
        onStepContinue: () => {
          currentStep + 1 != form.length &&
                  controllers[currentStep].text.length > 0
              ? {
                  goTo(currentStep + 1),
                  FocusScope.of(context).requestFocus(myFocusNode)
                }
              : {
                  setState(() => complete = true),
                  addPost(titleController.text, descriptionController.text),
                  titleController.text = '',
                  descriptionController.text = '',
                  //timeController.text = '',
                  Navigator.pop(context),
                }
        },
        onStepCancel: () => {
          if (currentStep > 0) {goTo(currentStep - 1)}
        },
        onStepTapped: (step) => goTo(step),
      ),
    );
  }
}
