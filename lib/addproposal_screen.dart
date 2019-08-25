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

  AddProposalFormState(this.addProposal);

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  addProposal(proposalTitleController.text, proposalSubtitleController.text);
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