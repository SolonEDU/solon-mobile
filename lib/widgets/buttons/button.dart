import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function function;
  final String label;
  final EdgeInsets margin;
  final double width;
  final double height;
  final Color color;

  Button({
    this.function,
    this.label,
    this.margin,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Align(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // print(constraints.maxWidth);
            final String text = label;
            final span = TextSpan(
              text: text,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
            );
            final tp = TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              maxLines: 1,
            ); // TODO: watch out for locale text direction; i remember smthg abt locale direction in the new way of app locales
            tp.layout(maxWidth: constraints.maxWidth);
            final tpSizeWidth = tp.size.width;
            // print('painter size width: ${tpSizeWidth}');
            // print(tpLineMetrics[tpLineMetrics.length - 1].lineNumber);
            return SizedBox(
              height: height,
              width: tpSizeWidth * 1.5 + 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30),
                ),
                color: color,
                onPressed: function,
                child: Text(
                  label,
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
