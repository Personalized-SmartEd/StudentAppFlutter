import 'package:flutter/material.dart';

class LDivider extends StatelessWidget {
  const LDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            indent: 20.0,
            endIndent: 10.0,
            thickness: 0.6,
          ),
        ),
        Text(
          "OR",
          // style: GoogleFonts.lato(
          //     color: Colors.blueGrey, fontSize: 10),
        ),
        Expanded(
          child: Divider(
            indent: 10.0,
            endIndent: 20.0,
            thickness: 0.6,
          ),
        ),
      ],
    );
  }
}
