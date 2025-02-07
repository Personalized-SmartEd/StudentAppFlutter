import 'package:flutter/material.dart';
import 'package:smarted/shared/constants/color.constants.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
    this.fontSize = 90,
    this.color = ColorConstants.primary,
  });

  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Zyra',
      style: TextStyle(
        fontFamily: 'Retrograde',
        fontSize: fontSize,
        color: color,
        height: 1,
      ),
    );
  }
}
