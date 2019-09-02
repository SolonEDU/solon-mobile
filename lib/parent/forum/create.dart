import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

class CreatePost extends StatefulWidget {
  final Function _addPost;
  CreatePost(this._addPost);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<Step> form = [];
  FocusNode _focusNode;

  List<TextEditingController> controllers =
      List.generate(2, (int index) => TextEditingController());

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

  void goTo(int step) {
    setState(() => {currentStep = step});
  }

  int currentStep = 0;

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
          controller: controllers[0],
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
          focusNode: _focusNode,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('description')),
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
                  FocusScope.of(context).requestFocus(_focusNode)
                }
              : {
                  widget._addPost(controllers[0].text, controllers[1].text),
                  controllers.forEach((controller) => {controller.clear()}),
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
