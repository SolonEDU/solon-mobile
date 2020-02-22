import 'dart:ui';
import 'package:flutter/material.dart';

class TextLayout {
  static LayoutBuilder fillLinesWithTextAndAppendEllipses({
    // this function is always assumed to render AT LEAST one line of text
    String rawText,
    int lines =
        3, // initialize number of lines to render to 3 if the argument was not specified
    bool keepLastLine =
        false, // initialize keepLastLine to false if the argument was not specified
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (rawText == '')
          return Text(rawText); // trivial case: empty rawText string

        final String text = rawText;
        final int textLength = text.length;
        TextStyle textStyle = TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,
          fontSize: 22,
        );
        final span = TextSpan(
          text: rawText,
          style: textStyle,
        );
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        ); // TODO: watch out for locale text direction
        tp.layout(maxWidth: constraints.maxWidth);
        final tpLineMetrics = tp.computeLineMetrics();
        print(tpLineMetrics[tpLineMetrics.length - 1].lineNumber);

        // TODO: This doesn't handle right-to-left text yet.; maybe textAffinity can fix.
        // select everything
        TextSelection selection =
            TextSelection(baseOffset: 0, extentOffset: span.text.length);

        // get a list of TextBoxes (Rects)
        List<TextBox> boxes = tp.getBoxesForSelection(selection);

        // Loop through each text box
        List<String> lineTexts = [];
        int start = 0;
        int end;
        int index = -1;
        for (TextBox box in boxes) {
          index += 1;

          // Uncomment this if you want to only get the whole line of text
          // (sometimes a single line may have multiple TextBoxes)
          if (box.left != 0.0) continue;

          if (index == 0) continue;
          // Go one logical pixel within the box and get the position
          // of the character in the string.
          end =
              tp.getPositionForOffset(Offset(box.left + 1, box.top + 1)).offset;
          // add the substring to the list of lines
          final line = text.substring(start, end);
          lineTexts.add(line);
          start = end;
        }
        // get the last substring
        final extra = text.substring(start);
        lineTexts.add(extra);
        print(lineTexts);

        // avoid RangeError where actual number of lines is less than default lines argument
        lines = lines >= lineTexts.length ? lineTexts.length : lines;

        // estimate the average width of a character, in pixels
        int totalTextWidth =
            (tpLineMetrics[0].width * (tpLineMetrics.length - 1) +
                    tpLineMetrics[tpLineMetrics.length - 1].width)
                .ceil();
        double avgCharPixelWidth = (totalTextWidth / textLength);
        int lastLineCharDiff = lineTexts[lineTexts.length - 1].length;
        int lastRenderedLineLength = lineTexts[lines - 1].length;
        print(avgCharPixelWidth);

        if (tpLineMetrics.length == 1) {
          // The text only has 1 line.
          return Text(
            text,
            style: textStyle,
          );
        }

        // text to be rendered onto the Text widget
        String renderedText = lineTexts.sublist(0, lines).join();
        int renderedTextLength = renderedText.length;

        // if (!keepLastLine) {
        //   return Text(
        //     '${renderedText.substring(0, renderedTextLength - 3)}...',
        //     style: textStyle,
        //   );
        // }

        if (lastRenderedLineLength.toDouble() *
                    avgCharPixelWidth + // if appending 3 ellipses to the last line is expected to overflow screen width
                3 * avgCharPixelWidth >
            constraints.maxWidth) {
          renderedText =
              '${renderedText.substring(0, renderedTextLength - 3)}...';
          print(renderedText);
        } else if (lastRenderedLineLength.toDouble() *
                    avgCharPixelWidth + // if appending 3 ellipses to the last line is expected to fit within the screen width
                3 * avgCharPixelWidth <=
            constraints.maxWidth) {
          renderedText = '${renderedText.substring(0, renderedTextLength)}...';
        }

        return Text(
          renderedText,
          style: textStyle,
        );
      },
    );
  }
}
