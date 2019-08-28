import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  final Function _addPost;
  CreatePost(this._addPost);

  @override
  _CreatePostState createState() => _CreatePostState(_addPost);
}

class _CreatePostState extends State<CreatePost> {
  List<Step> form = [];
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

  int currentStep = 0;
  bool complete = false;

  goTo(int step) {
    setState(() => {currentStep = step});
  }

  _CreatePostState(this.addPost);

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
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Stepper(
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
