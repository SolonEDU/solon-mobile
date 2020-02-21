import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final SearchDelegate delegate;

  SearchButton({
    this.delegate
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 45.0,
      child: RawMaterialButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: delegate,
          );
        },
        child: Icon(
          Icons.search,
          color: Colors.pink[400],
        ),
        shape: CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }
}
