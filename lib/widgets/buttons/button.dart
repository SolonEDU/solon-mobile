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
            print(constraints.maxWidth);
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
            ); // TODO: watch out for locale text direction
            tp.layout(maxWidth: constraints.maxWidth);
            final tpLineMetrics = tp.size.width;
            print('line metrics: ${tpLineMetrics}');
            // print(tpLineMetrics[tpLineMetrics.length - 1].lineNumber);
            return SizedBox(
              height: height,
              width: tpLineMetrics * 2.4, // TODO: janky as hell fix lata
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
                      fontFamily: 'Raleway', fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
