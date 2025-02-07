import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OTPFieldInput extends StatefulWidget {
  final Function(String val) onChanged;
  final bool autoFocus;
  final bool hasError;
  final EdgeInsets scrollPadding;
  final TextEditingController? controller;

  const OTPFieldInput(
      {super.key,
      required this.onChanged,
      required this.hasError,
      this.scrollPadding = const EdgeInsets.all(20),
      this.controller,
      this.autoFocus = true});

  @override
  State<OTPFieldInput> createState() => _OTPFieldInputState();
}

class _OTPFieldInputState extends State<OTPFieldInput> {
  @override
  Widget build(BuildContext context) {
    const size = 52.0;
    final defaultPinTheme = PinTheme(
      width: size,
      height: size,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        width: 1,
        color: const Color(0XFF1B1B1E),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      textStyle: const TextStyle(
        fontSize: 18,
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
    );

    return Pinput(
      controller: widget.controller,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: const Key("otpInput"),
      autofocus: widget.autoFocus,
      length: 6,
      scrollPadding: widget.scrollPadding,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      errorTextStyle: const TextStyle(color: Colors.red),
      defaultPinTheme: !widget.hasError ? defaultPinTheme : errorPinTheme,
      focusedPinTheme: focusedPinTheme,
      showCursor: true,
      onChanged: widget.onChanged,
    );
  }
}
