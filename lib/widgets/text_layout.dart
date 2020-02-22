import 'dart:ui';
import 'package:flutter/material.dart';

class TextLayout {
  static LayoutBuilder fillLinesWithTextAndAppendEllipses(
      {String rawText, int lines, bool renderLastLine}) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            textDirection:
                TextDirection.ltr); // TODO: watch out for locale text direction
        tp.layout(maxWidth: constraints.maxWidth);
        final tpLineMetrics = tp.computeLineMetrics();
        print(tpLineMetrics[tpLineMetrics.length - 1].lineNumber);

        // TODO: This doesn't handle right-to-left text yet.
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

        int totalTextWidth =
            (tpLineMetrics[0].width * (tpLineMetrics.length - 1) +
                    tpLineMetrics[tpLineMetrics.length - 1].width)
                .ceil();
        double avgCharPixelWidth = (totalTextWidth / textLength);
        int lastLineCharDiff = lineTexts[lineTexts.length - 1].length;
        print(avgCharPixelWidth);
        String renderText;

        if (renderLastLine != null && renderLastLine) {
          if (tpLineMetrics.length == 1) {
            // The text only has 1 line.
            // TODO: display the one-line text
            // return Text(
            //   widget.proposal.title,
            //   style: textStyle,
            // );
            renderText = text;
          } else if (lineTexts[lineTexts.length - 1].length +
                  (3 * avgCharPixelWidth) >
              constraints.maxWidth) {
            // (tpLineMetrics[tpLineMetrics.length - 1].width /
            //         avgCharPixelWidth)
            //     .ceil();

            renderText =
                text.substring(0, textLength - lastLineCharDiff - 3) + '...';
            print(renderText);
          } else if (lineTexts[lineTexts.length - 1].length +
                  (3 * avgCharPixelWidth) <=
              constraints.maxWidth) {
            renderText = text.substring(0, textLength) + '...';
          }
        } else {
          if (tpLineMetrics.length == 1) {
            // The text only has 1 line.
            // TODO: display the one-line text
            renderText = rawText;
          } else if (tpLineMetrics.length > 1) {
            int totalTextWidth =
                (tpLineMetrics[0].width * (tpLineMetrics.length - 1) +
                        tpLineMetrics[tpLineMetrics.length - 1].width)
                    .ceil();
            double avgCharPixelWidth = (totalTextWidth / textLength);
            int lastLineCharDiff = lineTexts[lineTexts.length - 1].length;
            // (tpLineMetrics[tpLineMetrics.length - 1].width /
            //         avgCharPixelWidth)
            //     .ceil();
            print(avgCharPixelWidth);
            renderText =
                text.substring(0, textLength - lastLineCharDiff - 3) + '...';
            print(renderText);
          }
        }

        return Text(
          renderText,
          style: textStyle,
          // maxLines: tpLineMetrics.length - 1,
        );
      },
    );
  }
}
