import 'package:flutter/material.dart';
import 'package:smarted/shared/theme/theme.dart';

class Heading42Bold extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final bool? underline;

  const Heading42Bold(
      {required this.text,
      super.key,
      this.style,
      this.color,
      this.textAlign,
      this.maxLines,
      this.overflow,
      this.letterSpacing,
      this.height,
      this.underline,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ZTheme.fs42.bold.merge(style).copyWith(
            color: color,
            letterSpacing: letterSpacing,
            height: height,
            fontWeight: fontWeight,
            decoration: underline != null
                ? underline!
                    ? TextDecoration.underline
                    : TextDecoration.none
                : null,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
