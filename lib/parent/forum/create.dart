import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context).translate('title')),
        isActive: currentStep == 0 ? true : false,
        state: currentStep == 0 ? StepState.editing : StepState.complete,
        content: TextFormField(
          autofocus: true,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('title')),
          controller: titleController,
          autovalidate: true,
        ),
      ),
      Step(
        title: Text(AppLocalizations.of(context).translate('description')),
        isActive: currentStep == 1 ? true : false,
        state: currentStep == 1
            ? StepState.editing
            : currentStep < 1 ? StepState.disabled : StepState.complete,
        content: TextFormField(
          autofocus: true,
          focusNode: myFocusNode,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('description')),
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
        title: Text(AppLocalizations.of(context).translate('createAPost')),
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
