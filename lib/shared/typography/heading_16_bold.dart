import 'package:smarted/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class Heading16Bold extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final bool? underline;

  const Heading16Bold({
    required this.text,
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.underline,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style == null
          ? ZTheme.fs16.bold.copyWith(
              color: color,
              letterSpacing: letterSpacing,
              height: height,
              decoration: underline != null
                  ? underline!
                      ? TextDecoration.underline
                      : TextDecoration.none
                  : null,
            )
          : ZTheme.fs16.bold.merge(style).copyWith(
                color: color,
                letterSpacing: letterSpacing,
                height: height,
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
