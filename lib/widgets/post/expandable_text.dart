import 'package:video_app/index.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int maxLines;
  final Color expandIconColor;
  final bool isEnabled;
  final Function onTap;

  const ExpandableText(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.maxLines,
      required this.expandIconColor,
      required this.isEnabled,
      required this.onTap});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  final bool _basicInformationIsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final TextSpan span = TextSpan(
        text: widget.text,
        style: widget.textStyle,
      );
      final TextPainter textPainter = TextPainter(
        text: span,
        maxLines: widget.maxLines,
        ellipsis: '...',
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: constraints.maxWidth);

      if (textPainter.didExceedMaxLines) {
        // exceeded
        return Row(
          crossAxisAlignment: _basicInformationIsExpanded
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                widget.text,
                style: widget.textStyle,
                maxLines: _isExpanded ? null : widget.maxLines,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.isEnabled
                    ? setState(() => _isExpanded = !_isExpanded)
                    : widget.onTap();
              },
              child: _isExpanded
                  ? Icon(Icons.expand_less_rounded,
                      color: widget.expandIconColor, size: 20)
                  : Icon(Icons.expand_more_rounded,
                      color: widget.expandIconColor, size: 20),
            ),
          ],
        );
      } else {
        // not exceeded
        return Text(
          widget.text,
          style: widget.textStyle,
        );
      }
    });
  }
}
