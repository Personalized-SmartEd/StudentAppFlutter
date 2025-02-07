import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:smarted/shared/typography/body_16_regular.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String label;
  final bool numbersOnly;
  final int? maxCharacters;
  final Widget? prefix;
  final Widget? suffix; // Add this line
  final Function(String)? onChanged;

  const TextInput({
    super.key,
    this.controller,
    this.hintText,
    required this.label,
    this.numbersOnly = false,
    this.maxCharacters,
    this.prefix,
    this.suffix, // Add this line
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Body16Regular(text: label),
        const Gap(2),
        TextField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: numbersOnly ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (numbersOnly) FilteringTextInputFormatter.digitsOnly,
            if (maxCharacters != null)
              LengthLimitingTextInputFormatter(maxCharacters),
          ],
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
