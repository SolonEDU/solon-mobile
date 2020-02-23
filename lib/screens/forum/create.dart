import 'package:flutter/material.dart';
import 'package:Solon/models/message.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';
import 'package:Solon/widgets/buttons/preventable_button.dart';

typedef APIFunction<T> = Future<T> Function(
  String,
  String,
  DateTime,
);

class CreatePost extends StatefulWidget {
  final APIFunction<Message> _addPost;
  CreatePost(this._addPost);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String _title, _description;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: AppLocalizations.of(context).translate("newPost"),
      ),
      key: _scaffoldKey,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            primary: false,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  AppLocalizations.of(context).translate("title"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("pleaseEnterATitle");
                    }
                    return null;
                  },
                  onSaved: (input) => _title = input,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context).translate("description"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 30, top: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink[400],
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  validator: (input) {
                    if (input.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("pleaseEnterADescription");
                    }
                    return null;
                  },
                  onSaved: (input) => _description = input,
                ),
              ),
              PreventableButton(
                body: <Map>[
                  {
                    "color": Colors.pink[200],
                    "height": 55.0,
                    "function": createPost,
                    "margin": const EdgeInsets.only(top: 15, bottom: 10),
                    "label":
                        AppLocalizations.of(context).translate("createPost"),
                  }
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<bool> createPost() async* {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      yield true;
      formState.save();
      widget
          ._addPost(
        _title,
        _description,
        DateTime.now(),
      )
          .then(
        (message) {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
        },
      );
    } else {
      yield false;
    }
  }
}
