import 'package:smarted/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class Body12Regular extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final bool? underline;

  const Body12Regular({
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
          ? ZTheme.fs12.regular.copyWith(
              color: color,
              letterSpacing: letterSpacing,
              height: height,
              decoration: underline != null
                  ? underline!
                      ? TextDecoration.underline
                      : TextDecoration.none
                  : null,
            )
          : ZTheme.fs12.regular.merge(style).copyWith(
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
