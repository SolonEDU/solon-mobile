import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  PageAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.black,
        onPressed: () => {
          FocusScope.of(context).unfocus(),
          Navigator.pop(context),
        },
      ),
      title: Text(
        (title != null) ? title : '',
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
