import 'package:smarted/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:smarted/shared/typography/heading_16_semibold.dart';

class SecondaryButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isDisabled;
  final String label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsetsGeometry? padding;
  final bool forBottomSheet;
  final bool isLoading;
  final ButtonStyle? customButtonStyle;
  final Widget? customText;
  final Color? customColor;

  const SecondaryButton(
      {super.key,
      required this.onPressed,
      this.isDisabled = false,
      required this.label,
      this.leftIcon,
      this.rightIcon,
      this.padding,
      this.forBottomSheet = false,
      this.isLoading = false,
      this.customButtonStyle,
      this.customText,
      this.customColor});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle secondaryButtonStyle = widget.customButtonStyle ??
        OutlinedButton.styleFrom(
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // remove default margin
          minimumSize: Size.zero, // remove default padding
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          splashFactory: NoSplash.splashFactory, // remove ripple effect
          shadowColor: Colors.transparent, // button shadow on pressed
          side: widget.customColor != null
              ? BorderSide(color: widget.customColor!)
              : null,
          foregroundColor: widget.customColor,
        );

    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 0.95,
      ).animate(_controller),
      child: Listener(
        onPointerDown: (details) {
          if (!widget.isDisabled && mounted) _controller.forward();
        },
        onPointerUp: (details) {
          if (!widget.isDisabled && mounted) _controller.reverse();
        },
        child: OutlinedButton(
          onLongPress: null,
          onPressed: widget.isLoading
              ? null
              : (widget.isDisabled ? null : widget.onPressed),
          style: secondaryButtonStyle,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.leftIcon != null) widget.leftIcon!,
              if (widget.leftIcon != null) const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: double.infinity),
                child: (widget.isLoading)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: ZTheme.foregroundColor),
                      )
                    : widget.customText ??
                        Heading16Semibold(
                          text: widget.label,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
              ),
              if (widget.rightIcon != null) const SizedBox(width: 8),
              if (widget.rightIcon != null) widget.rightIcon!
            ],
          ),
        ),
      ),
    );
  }
}
