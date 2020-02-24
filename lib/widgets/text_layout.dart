import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TextLayout {
  static LayoutBuilder fillLinesWithTextAndAppendTrail({
    // this function is always assumed to render AT LEAST one line of text
    @required String rawText,
    String trail, // trailing string to append
    String langCode = 'en', // English by default
    TextStyle textStyle,
    int lines =
        3, // initialize number of lines to render to 3 if the argument was not specified; keep in mind that the raw text may not reach up to 3 lines, in which the lines variable value will be adjusted accordingly below
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        TextDirection renderTextDirection;
        renderTextDirection = [
          'ar',
          'fa',
          'he',
          'ps',
          'ur',
        ].contains(langCode)
            ? TextDirection.rtl
            : TextDirection.ltr;

        if (rawText == '')
          return Text(
            rawText,
            textDirection: renderTextDirection,
          ); // trivial case: empty rawText string

        final String text = rawText;
        final span = TextSpan(
          text: rawText,
          style: textStyle,
        );
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        ); // TODO: watch out for locale text direction
        tp.layout(maxWidth: constraints.maxWidth);
        // final tpLineMetrics = tp.computeLineMetrics();
        // print(tpLineMetrics[tpLineMetrics.length - 1].lineNumber);

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
        // print('line texts: $lineTexts');
        final int lineTextsLength = lineTexts.length;

        // avoid RangeError where actual number of lines is less than default lines argument
        lines = lines >= lineTextsLength ? lineTextsLength : lines;
        // print('lines: $lines');

        if (lineTextsLength == 1) {
          // The text only has 1 line.
          return Text(
            text,
            style: textStyle,
            textDirection: renderTextDirection,
          );
        }

        // text to be rendered onto the Text widget
        String renderedText = lineTexts.sublist(0, lines).join();
        int renderedTextLength = renderedText.length;

        if (lineTextsLength <= lines) {
          // if there are less or equal number of lines of raw text than number of lines to render
          renderedText = '${renderedText.substring(0, renderedTextLength)}';
        } else {
          // if there are more lines of raw text than lines to render
          renderedText =
              '${renderedText.substring(0, renderedTextLength - 3)}$trail';
        }

        return Text(
          renderedText,
          style: textStyle,
          textDirection:
              renderTextDirection, // TODO: map lang code to correct text direction here; rtl lang codes: ['ar', 'fa', 'he', 'ps', 'ur']
        );
      },
    );
  }
}
