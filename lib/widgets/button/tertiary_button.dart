import 'package:flutter/material.dart';
import 'package:smarted/shared/typography/heading_14_semibold.dart';

class TertiaryButton extends StatefulWidget {
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
  const TertiaryButton({
    super.key,
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
  });

  @override
  State<TertiaryButton> createState() => _TertiaryButtonState();
}

class _TertiaryButtonState extends State<TertiaryButton>
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
    final ButtonStyle tertiaryButtonStyle = widget.customButtonStyle ??
        TextButton.styleFrom(
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // remove default margin
          minimumSize: Size.zero, // remove default padding
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          splashFactory: NoSplash.splashFactory, // remove ripple effect
          shadowColor: Colors.transparent, // button shadow on pressed
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
        child: TextButton(
          onLongPress: null,
          onPressed: widget.isDisabled ? null : widget.onPressed,
          style: tertiaryButtonStyle,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.leftIcon != null) widget.leftIcon!,
              if (widget.leftIcon != null) const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: double.infinity),
                child: (widget.isLoading)
                    ? const CircularProgressIndicator()
                    : widget.customText ??
                        Heading14Semibold(
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
