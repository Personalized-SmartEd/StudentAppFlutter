import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarted/shared/constants/color.constants.dart';
import 'package:smarted/shared/constants/textstyle.constant.dart';
import 'package:smarted/shared/text_styles/text_styles.dart';

class InputBox extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;

  const InputBox({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.dmSans(
        color: theme.colorScheme.onSurface,
        fontSize: 16.0,
        fontStyle: FontStyle.italic,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.dmSans(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontStyle: FontStyle.italic,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
